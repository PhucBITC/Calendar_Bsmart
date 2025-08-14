package com.bsmart.service;

import com.bsmart.domain.FixedSchedule;
import com.bsmart.domain.GeneratedScheduleDTO;
import com.bsmart.domain.FixedScheduleDTO;
import com.bsmart.domain.Task;
import com.bsmart.domain.User;
import com.bsmart.repository.FixedScheduleRepository;
import com.bsmart.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;

/**
 * Service xử lý lịch cố định và lập lịch tự động dựa trên thuật toán:
 * - EDF (Earliest Deadline First)
 * - Greedy (Ưu tiên cao)
 * - Interval Scheduling (Không trùng lịch)
 */
@Service
public class FixedScheduleService {

    @Autowired
    private FixedScheduleRepository fixedScheduleRepository;

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private UserService userService;

    // Lấy tất cả lịch học cố định
    public List<FixedSchedule> getAllSchedules() {
        return fixedScheduleRepository.findAll();
    }

    // Lấy schedule theo user
    public List<FixedSchedule> getSchedulesByUser(User user) {
        return fixedScheduleRepository.findByUser(user);
    }

    // Lấy schedule theo username
    public List<FixedSchedule> getSchedulesByUsername(String username) {
        User user = userService.getCurrentUser(username);
        return fixedScheduleRepository.findByUser(user);
    }

    // FixedScheduleService.java
    public FixedSchedule saveSchedule(FixedSchedule schedule) {
        return fixedScheduleRepository.save(schedule); // Return saved object với ID
    }

    // Lưu schedule với user
    public FixedSchedule saveSchedule(FixedSchedule schedule, String username) {
        User user = userService.getCurrentUser(username);
        schedule.setUser(user);
        return fixedScheduleRepository.save(schedule);
    }

    // Lấy lịch theo ID
    public FixedSchedule getScheduleById(Long id) {
        return fixedScheduleRepository.findById(id).orElse(null);
    }

    // Xoá lịch
    public void deleteSchedule(Long id) {
        fixedScheduleRepository.deleteById(id);
    }

    // Kiểm tra schedule có thuộc về user không
    public boolean isScheduleOwnedByUser(Long scheduleId, String username) {
        User user = userService.getCurrentUser(username);
        Optional<FixedSchedule> schedule = fixedScheduleRepository.findById(scheduleId);
        return schedule.isPresent() && schedule.get().getUser().getId().equals(user.getId());
    }

    /**
     * Sinh lịch thông minh sử dụng kết hợp EDF và Greedy trên danh sách Task hiện có và chèn vào các khoảng trống.
     * Giản lược: Vì Task chưa có duration theo phút và deadline chi tiết, dùng các trường hiện có theo ngày và giờ.
     */
    public List<GeneratedScheduleDTO> generateSmartSchedule(String username) {
        User user = userService.getCurrentUser(username);

        // Lấy fixed schedules của user theo DTO semantics: dayOfWeek là yyyy-MM-dd
        List<FixedSchedule> fixed = fixedScheduleRepository.findByUser(user);

        // Lấy tasks của user (không sửa repository: lọc tại memory)
        List<Task> allTasks = taskRepository.findAll();
        List<Task> userTasks = new ArrayList<>();
        for (Task t : allTasks) {
            if (t != null && t.getDeadline() != null && t.getDuration() > 0 && t.getPriority() != null) {
                if (t.getDeadline() != null && t.getDuration() > 0 && t.getPriority() != null) {
                    // thuộc về user?
                    try {
                        var taskUserField = t.getClass().getDeclaredField("user");
                        taskUserField.setAccessible(true);
                        Object taskUser = taskUserField.get(t);
                        if (taskUser instanceof User u && u.getId() != null && u.getId().equals(user.getId())) {
                            userTasks.add(t);
                        }
                    } catch (Exception ignore) {
                        // Nếu không ánh xạ được thì bỏ qua (không sửa Task)
                    }
                }
            }
        }

        // Sắp xếp EDF (deadline tăng dần) + Greedy (ưu tiên HIGH > MEDIUM > LOW)
        userTasks.sort((a, b) -> {
            int cmpDeadline = a.getDeadline().compareTo(b.getDeadline());
            if (cmpDeadline != 0) return cmpDeadline;
            return comparePriority(b.getPriority(), a.getPriority()); // HIGH trước
        });

        // Tập lịch gợi ý sẽ sinh trong 14 ngày tiếp theo, tôn trọng deadline
        LocalDate today = LocalDate.now();
        LocalDate horizon = today.plusDays(14);

        // Map ngày -> danh sách khoảng bận (từ fixed schedule)
        Map<LocalDate, List<TimeInterval>> busyByDate = buildBusyMapFromFixed(fixed);

        // Giờ làm việc mặc định 08:00-20:00
        LocalTime workStart = LocalTime.of(8, 0);
        LocalTime workEnd = LocalTime.of(20, 0);

        List<GeneratedScheduleDTO> suggestions = new ArrayList<>();

        for (Task task : userTasks) {
            int requiredMinutes = task.getDuration() * 60;
            boolean placed = false;

            // Duyệt ngày từ hôm nay -> min(deadline, horizon)
            LocalDate lastDate = task.getDeadline().isBefore(horizon) ? task.getDeadline() : horizon;
            for (LocalDate d = today; !d.isAfter(lastDate); d = d.plusDays(1)) {
                List<TimeInterval> busy = busyByDate.computeIfAbsent(d, k -> new ArrayList<>());
                List<TimeInterval> free = invertToFree(busy, workStart, workEnd);
                // Greedy chọn free slot sớm nhất đủ dài
                for (TimeInterval slot : free) {
                    long slotMinutes = ChronoUnit.MINUTES.between(slot.start, slot.end);
                    if (slotMinutes >= requiredMinutes) {
                        LocalTime st = slot.start;
                        LocalTime en = st.plusMinutes(requiredMinutes);
                        // đánh dấu bận để các task sau không đè lên
                        busy.add(new TimeInterval(st, en));
                        normalizeBusy(busy);
                        suggestions.add(new GeneratedScheduleDTO(
                                task.getTitle(),
                                d.toString(),
                                st.toString(),
                                en.toString(),
                                task.getPriority().name()));
                        placed = true;
                        break;
                    }
                }
                if (placed) break;
            }
            // Nếu vẫn chưa đặt được trước deadline, thử sau deadline đến horizon
            if (!placed) {
                for (LocalDate d = task.getDeadline().plusDays(1); !d.isAfter(horizon); d = d.plusDays(1)) {
                    List<TimeInterval> busy = busyByDate.computeIfAbsent(d, k -> new ArrayList<>());
                    List<TimeInterval> free = invertToFree(busy, workStart, workEnd);
                    for (TimeInterval slot : free) {
                        long slotMinutes = ChronoUnit.MINUTES.between(slot.start, slot.end);
                        if (slotMinutes >= requiredMinutes) {
                            LocalTime st = slot.start;
                            LocalTime en = st.plusMinutes(requiredMinutes);
                            busy.add(new TimeInterval(st, en));
                            normalizeBusy(busy);
                            suggestions.add(new GeneratedScheduleDTO(
                                    task.getTitle(),
                                    d.toString(),
                                    st.toString(),
                                    en.toString(),
                                    task.getPriority().name()));
                            placed = true;
                            break;
                        }
                    }
                    if (placed) break;
                }
            }
        }

        return suggestions;
    }

    private static int comparePriority(Task.Priority p1, Task.Priority p2) {
        // HIGH > MEDIUM > LOW
        return Integer.compare(priorityScore(p1), priorityScore(p2));
    }

    private static int priorityScore(Task.Priority p) {
        return switch (p) {
            case HIGH -> 3;
            case MEDIUM -> 2;
            case LOW -> 1;
        };
    }

    private static class TimeInterval {
        final LocalTime start;
        final LocalTime end;
        TimeInterval(LocalTime s, LocalTime e) { this.start = s; this.end = e; }
    }

    private static Map<LocalDate, List<TimeInterval>> buildBusyMapFromFixed(List<FixedSchedule> fixed) {
        Map<LocalDate, List<TimeInterval>> map = new HashMap<>();
        for (FixedSchedule fs : fixed) {
            try {
                if (fs.getDayOfWeek() == null || fs.getStartTime() == null || fs.getEndTime() == null) continue;
                LocalDate date = LocalDate.parse(fs.getDayOfWeek());
                map.computeIfAbsent(date, k -> new ArrayList<>())
                        .add(new TimeInterval(fs.getStartTime(), fs.getEndTime()));
            } catch (Exception ignore) {
            }
        }
        // chuẩn hóa mỗi ngày
        for (List<TimeInterval> list : map.values()) {
            normalizeBusy(list);
        }
        return map;
    }

    private static void normalizeBusy(List<TimeInterval> busy) {
        if (busy.isEmpty()) return;
        busy.sort(Comparator.comparing(a -> a.start));
        List<TimeInterval> merged = new ArrayList<>();
        TimeInterval cur = busy.get(0);
        for (int i = 1; i < busy.size(); i++) {
            TimeInterval n = busy.get(i);
            if (!n.start.isAfter(cur.end)) {
                // overlap
                cur = new TimeInterval(cur.start, max(cur.end, n.end));
            } else {
                merged.add(cur);
                cur = n;
            }
        }
        merged.add(cur);
        busy.clear();
        busy.addAll(merged);
    }

    private static LocalTime max(LocalTime a, LocalTime b) { return a.isAfter(b) ? a : b; }

    private static List<TimeInterval> invertToFree(List<TimeInterval> busy, LocalTime dayStart, LocalTime dayEnd) {
        List<TimeInterval> free = new ArrayList<>();
        LocalTime cur = dayStart;
        List<TimeInterval> sorted = new ArrayList<>(busy);
        sorted.sort(Comparator.comparing(i -> i.start));
        for (TimeInterval b : sorted) {
            if (b.start.isAfter(cur)) {
                free.add(new TimeInterval(cur, b.start));
            }
            if (b.end.isAfter(cur)) cur = b.end;
        }
        if (cur.isBefore(dayEnd)) {
            free.add(new TimeInterval(cur, dayEnd));
        }
        return free;
    }
}
