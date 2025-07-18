package com.bsmart.service;

import com.bsmart.domain.FixedSchedule;
import com.bsmart.domain.GeneratedScheduleDTO;
import com.bsmart.domain.Task;
import com.bsmart.repository.FixedScheduleRepository;
import com.bsmart.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
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

    // Lấy tất cả lịch học cố định
    public List<FixedSchedule> getAllSchedules() {
        return fixedScheduleRepository.findAll();
    }

    // Lưu hoặc cập nhật lịch học cố định
    public void saveSchedule(FixedSchedule schedule) {
        fixedScheduleRepository.save(schedule);
    }

    // Lấy lịch theo ID
    public FixedSchedule getScheduleById(Long id) {
        return fixedScheduleRepository.findById(id).orElse(null);
    }

    // Xoá lịch
    public void deleteSchedule(Long id) {
        fixedScheduleRepository.deleteById(id);
    }

    // ================== Thuật toán lập lịch tự động ====================
    public List<GeneratedScheduleDTO> generateOptimalSchedule() {
        List<FixedSchedule> fixedSchedules = fixedScheduleRepository.findAll();
        List<Task> tasks = taskRepository.findAll();

        String[] days = { "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY" };
        Map<String, List<TimeSlot>> availableSlots = new HashMap<>();

        // Khởi tạo slot trống ban đầu: 08:00 - 22:00 mỗi ngày
        for (String day : days) {
            availableSlots.put(day, getInitialSlots());
        }

        // Loại bỏ các khoảng thời gian đã bị chiếm bởi lịch học cố định
        for (FixedSchedule fs : fixedSchedules) {
            List<TimeSlot> current = availableSlots.get(fs.getDayOfWeek());
            if (current != null) {
                availableSlots.put(fs.getDayOfWeek(),
                        subtractSlot(current, new TimeSlot(fs.getStartTime(), fs.getEndTime())));
            }
        }

        // So sánh ưu tiên rõ ràng
        Comparator<Task.Priority> priorityComparator = Comparator.comparingInt(priority -> {
            switch (priority) {
                case HIGH:
                    return 1;
                case MEDIUM:
                    return 2;
                case LOW:
                    return 3;
                default:
                    return 4;
            }
        });

        // Sắp xếp theo deadline gần nhất → rồi theo mức độ ưu tiên
        tasks.sort(
                Comparator.comparing(Task::getDeadline)
                        .thenComparing(Task::getPriority, priorityComparator));

        List<GeneratedScheduleDTO> result = new ArrayList<>();

        for (Task task : tasks) {
            int duration = task.getDuration(); // giờ
            boolean scheduled = false;

            for (String day : days) {
                List<TimeSlot> slots = availableSlots.get(day);
                if (slots == null || slots.isEmpty())
                    continue;

                // Tìm nhiều slot cộng lại đủ thời gian
                int remaining = duration;
                List<TimeSlot> usedSlots = new ArrayList<>();

                for (TimeSlot slot : slots) {
                    if (slot.getDuration() <= 0)
                        continue;

                    usedSlots.add(slot);
                    remaining -= slot.getDuration();

                    if (remaining <= 0)
                        break;
                }

                if (remaining <= 0) {
                    // Gán thời gian từ slot đầu đến slot cuối (chia nhỏ nếu cần)
                    LocalTime start = usedSlots.get(0).getStartTime();
                    int totalHours = duration;
                    LocalTime end = start;

                    for (TimeSlot s : usedSlots) {
                        int hours = Math.min(s.getDuration(), totalHours);
                        end = s.getStartTime().plusHours(hours);
                        totalHours -= hours;
                        if (totalHours <= 0)
                            break;
                    }

                    result.add(new GeneratedScheduleDTO(
                            task.getTitle(), day,
                            start.toString(), end.toString(),
                            task.getPriority().name()));

                    // Cập nhật slot còn trống sau khi dùng
                    TimeSlot usedTime = new TimeSlot(start, end);
                    availableSlots.put(day, subtractSlot(slots, usedTime));

                    scheduled = true;
                    break;
                }
            }
        }

        return result;
    }

    // ================ Các hàm hỗ trợ ================

    private List<TimeSlot> getInitialSlots() {
        List<TimeSlot> slots = new ArrayList<>();
        slots.add(new TimeSlot(LocalTime.of(8, 0), LocalTime.of(22, 0)));
        return slots;
    }

    private List<TimeSlot> subtractSlot(List<TimeSlot> slots, TimeSlot remove) {
        List<TimeSlot> result = new ArrayList<>();

        for (TimeSlot slot : slots) {
            LocalTime slotStart = slot.getStartTime();
            LocalTime slotEnd = slot.getEndTime();
            LocalTime removeStart = remove.getStartTime();
            LocalTime removeEnd = remove.getEndTime();

            // Trường hợp: hoàn toàn không giao nhau
            if (removeEnd.compareTo(slotStart) <= 0 || removeStart.compareTo(slotEnd) >= 0) {
                result.add(slot);
            }
            // Có giao nhau
            else {
                // Phần còn lại trước khoảng remove
                if (removeStart.compareTo(slotStart) > 0) {
                    result.add(new TimeSlot(slotStart, removeStart));
                }

                // Phần còn lại sau khoảng remove
                if (removeEnd.compareTo(slotEnd) < 0) {
                    result.add(new TimeSlot(removeEnd, slotEnd));
                }
            }

        }

        return result;
    }

    private String addHoursToTime(String time, int hours) {
        LocalTime t = LocalTime.parse(time);
        // return t.plusHours(hours).toString();
        return t.plusHours(hours).format(DateTimeFormatter.ofPattern("HH:mm")); // --> "14:00"

    }

    // ================ Class nội bộ để biểu diễn slot thời gian ================

    private static class TimeSlot {
        private final LocalTime startTime;
        private final LocalTime endTime;

        public TimeSlot(LocalTime startTime, LocalTime endTime) {
            this.startTime = startTime;
            this.endTime = endTime;
        }

        public LocalTime getStartTime() {
            return startTime;
        }

        public LocalTime getEndTime() {
            return endTime;
        }

        public int getDuration() {
            return endTime.getHour() - startTime.getHour(); // đơn giản hóa
        }

        // Dành cho in ra hoặc hiển thị
        public String getStartTimeString() {
            return startTime.toString();
        }

        public String getEndTimeString() {
            return endTime.toString();
        }
    }
}
