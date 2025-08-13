package com.bsmart.service;

import com.bsmart.domain.FixedSchedule;
import com.bsmart.domain.GeneratedScheduleDTO;
import com.bsmart.domain.Task;
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

    // Hàm phân bổ thời gian hợp lý
    public List<GeneratedScheduleDTO> generateBalancedSchedule() {
        List<FixedSchedule> fixedSchedules = fixedScheduleRepository.findAll();
        List<Task> tasks = taskRepository.findAll();
        LocalDate today = LocalDate.now();

        String[] days = { "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY" };
        Map<String, List<TimeSlot>> availableSlots = new HashMap<>();

        // Khởi tạo khung giờ trống ban đầu
        for (String day : days) {
            availableSlots.put(day, getInitialSlots());
        }

        // Loại bỏ các slot bị chiếm bởi lịch học cố định
        for (FixedSchedule fs : fixedSchedules) {
            List<TimeSlot> current = availableSlots.get(fs.getDayOfWeek());
            if (current != null) {
                availableSlots.put(fs.getDayOfWeek(),
                        subtractSlot(current, new TimeSlot(fs.getStartTime(), fs.getEndTime())));
            }
        }

        // Comparator cho ưu tiên
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

        // Sắp xếp task theo deadline trước, ưu tiên sau
        tasks.sort(
                Comparator.comparing(Task::getDeadline)
                        .thenComparing(Task::getPriority, priorityComparator));

        List<GeneratedScheduleDTO> result = new ArrayList<>();

        // Duyệt từng task và chia đều
        for (Task task : tasks) {
            int totalDuration = task.getDuration(); // Tổng số giờ
            LocalDate deadline = task.getDeadline();
            long daysLeft = ChronoUnit.DAYS.between(today, deadline) + 1; // Số ngày còn lại

            if (daysLeft <= 0) {
                daysLeft = 1; // Nếu deadline <= hôm nay
            }

            // Số giờ mỗi ngày (chia đều)
            int hoursPerDay = (int) Math.ceil((double) totalDuration / daysLeft);

            LocalDate currentDay = today;
            while (totalDuration > 0 && !currentDay.isAfter(deadline)) {
                String dayOfWeek = currentDay.getDayOfWeek().toString();
                List<TimeSlot> slots = availableSlots.get(dayOfWeek);

                if (slots != null && !slots.isEmpty()) {
                    for (TimeSlot slot : new ArrayList<>(slots)) {
                        int allocate = Math.min(hoursPerDay, totalDuration);

                        if (slot.getDuration() >= allocate) {
                            LocalTime start = slot.getStartTime();
                            LocalTime end = start.plusHours(allocate);

                            result.add(new GeneratedScheduleDTO(
                                    task.getTitle(),
                                    dayOfWeek,
                                    start.toString(),
                                    end.toString(),
                                    task.getPriority().name()));

                            totalDuration -= allocate;

                            // Cập nhật slot
                            TimeSlot used = new TimeSlot(start, end);
                            availableSlots.put(dayOfWeek, subtractSlot(slots, used));
                            break; // Chuyển sang ngày tiếp theo
                        }
                    }
                }
                currentDay = currentDay.plusDays(1); // Chuyển ngày
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

    // Hàm tối ưu thời gian sớm nhất để hoàn thành công việc
    public List<GeneratedScheduleDTO> generateOptimalSchedule() {
        List<FixedSchedule> fixedSchedules = fixedScheduleRepository.findAll();
        List<Task> tasks = taskRepository.findAll();

        String[] days = { "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY" };
        Map<String, List<TimeSlot>> availableSlots = new HashMap<>();
        Map<String, Integer> dailyLoad = new HashMap<>();

        for (String day : days) {
            availableSlots.put(day, getInitialSlots());
            dailyLoad.put(day, 0); // số giờ đã sử dụng
        }

        // Trừ slot bị chiếm
        for (FixedSchedule fs : fixedSchedules) {
            List<TimeSlot> current = availableSlots.get(fs.getDayOfWeek());
            if (current != null) {
                availableSlots.put(fs.getDayOfWeek(),
                        subtractSlot(current, new TimeSlot(fs.getStartTime(), fs.getEndTime())));
            }
        }

        // Sắp xếp: Deadline gần nhất trước, ưu tiên cao hơn
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

        tasks.sort(
                Comparator.comparing(Task::getDeadline)
                        .thenComparing(Task::getPriority, priorityComparator));

        List<GeneratedScheduleDTO> result = new ArrayList<>();

        for (Task task : tasks) {
            int duration = task.getDuration();
            boolean scheduled = false;

            // Tìm ngày có ít workload nhất còn đủ slot
            String bestDay = null;
            TimeSlot bestSlot = null;

            for (String day : days) {
                List<TimeSlot> slots = availableSlots.get(day);
                for (TimeSlot slot : slots) {
                    if (slot.getDuration() >= duration) {
                        if (bestDay == null || dailyLoad.get(day) < dailyLoad.get(bestDay)) {
                            bestDay = day;
                            bestSlot = slot;
                        }
                    }
                }
            }

            // Nếu tìm được ngày tốt nhất
            if (bestDay != null && bestSlot != null) {
                String startTime = bestSlot.getStartTimeString();
                String endTime = addHoursToTime(startTime, duration);

                result.add(new GeneratedScheduleDTO(
                        task.getTitle(), bestDay, startTime, endTime, task.getPriority().name()));

                // Cập nhật lại slot và workload
                TimeSlot used = new TimeSlot(LocalTime.parse(startTime), LocalTime.parse(endTime));
                List<TimeSlot> updatedSlots = subtractSlot(availableSlots.get(bestDay), used);
                availableSlots.put(bestDay, updatedSlots);
                dailyLoad.put(bestDay, dailyLoad.get(bestDay) + duration);

                scheduled = true;
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
