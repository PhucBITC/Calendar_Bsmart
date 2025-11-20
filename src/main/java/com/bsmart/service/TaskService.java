package com.bsmart.service;

import com.bsmart.domain.FixedSchedule;
import com.bsmart.domain.Task;
import com.bsmart.domain.User;
import com.bsmart.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class TaskService {

    @Autowired
    private TaskRepository taskRepository;

    @Autowired
    private FixedScheduleService fixedScheduleService;

    // Lấy tất cả nhiệm vụ
    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    // Lấy tasks theo user
    public List<Task> getTasksByUser(User user) {
        return taskRepository.findByUser(user);
    }

    // Lưu nhiệm vụ
    public Task saveTask(Task task) {
        return taskRepository.save(task);
    }

    public void deleteTaskById(Long id) {
        taskRepository.deleteById(id);
    }

    public Task getTaskById(Long id) {
        Optional<Task> optional = taskRepository.findById(id);
        return optional.orElse(null);
    }

    // --- Schedule Generation Logic ---

    private static class TimeSlot {
        int startMinutes;
        int endMinutes;

        TimeSlot(int startMinutes, int endMinutes) {
            this.startMinutes = startMinutes;
            this.endMinutes = endMinutes;
        }
    }

    public List<Map<String, Object>> generateTaskScheduleSuggestions(
            Task task, Integer repeatCount, String startHour, String endHour,
            Integer breakTime, Boolean useEDF, Boolean useGreedy) {

        List<Map<String, Object>> suggestions = new ArrayList<>();
        int workStartMinutes = timeToMinutes(startHour);
        int workEndMinutes = timeToMinutes(endHour);
        int taskDuration = task.getEstimatedDuration() != null ? task.getEstimatedDuration() : 60;
        User currentUser = task.getUser();
        List<FixedSchedule> existingSchedules = fixedScheduleService.getSchedulesByUser(currentUser);
        LocalDate startDate = LocalDate.now();
        LocalDate deadline = task.getDeadline();
        LocalTime now = LocalTime.now();
        int currentMinutes = now.getHour() * 60 + now.getMinute();
        int createdCount = 0;
        LocalDate currentDate = startDate;

        while (createdCount < repeatCount && !currentDate.isAfter(deadline)) {
            Map<String, Object> slot = findAvailableSlot(
                    currentDate, task, taskDuration, workStartMinutes, workEndMinutes,
                    breakTime, existingSchedules, currentMinutes, useEDF, useGreedy);

            if (slot != null) {
                suggestions.add(slot);
                createdCount++;
                addToExistingSchedules(existingSchedules, slot, breakTime);
            }
            currentDate = currentDate.plusDays(1);
        }

        suggestions.sort((a, b) -> {
            LocalDate dateA = LocalDate.parse((String) a.get("dayOfWeek"));
            LocalDate dateB = LocalDate.parse((String) b.get("dayOfWeek"));
            if (!dateA.equals(dateB)) {
                return dateA.compareTo(dateB);
            }
            return ((String) a.get("startTime")).compareTo((String) b.get("startTime"));
        });

        return suggestions;
    }

    private Map<String, Object> findAvailableSlot(
            LocalDate date, Task task, int taskDuration, int workStartMinutes,
            int workEndMinutes, Integer breakTime, List<FixedSchedule> existingSchedules,
            int currentMinutes, Boolean useEDF, Boolean useGreedy) {

        List<TimeSlot> busySlots = getBusySlotsForDate(date, existingSchedules);
        List<TimeSlot> freeSlots = findFreeSlots(workStartMinutes, workEndMinutes, busySlots);

        for (TimeSlot freeSlot : freeSlots) {
            int availableDuration = freeSlot.endMinutes - freeSlot.startMinutes;
            int requiredDuration = taskDuration + (breakTime != null ? breakTime : 0);

            if (availableDuration >= requiredDuration) {
                int slotStart = freeSlot.startMinutes;
                if (date.equals(LocalDate.now()) && slotStart < currentMinutes) {
                    slotStart = currentMinutes;
                }

                if (freeSlot.endMinutes - slotStart >= requiredDuration) {
                    return createScheduleSuggestion(task, date, slotStart, slotStart + taskDuration, useEDF, useGreedy);
                }
            }
        }
        return null; // Placeholder
    }

    private List<TimeSlot> getBusySlotsForDate(LocalDate date, List<FixedSchedule> existingSchedules) {
        List<TimeSlot> busySlots = new ArrayList<>();
        String dateStr = date.toString();
        for (FixedSchedule schedule : existingSchedules) {
            if (dateStr.equals(schedule.getDayOfWeek())) {
                busySlots.add(new TimeSlot(timeToMinutes(schedule.getStartTime().toString()),
                        timeToMinutes(schedule.getEndTime().toString())));
            }
        }
        busySlots.sort((a, b) -> Integer.compare(a.startMinutes, b.startMinutes));
        return busySlots;
    }

    private List<TimeSlot> findFreeSlots(int workStartMinutes, int workEndMinutes, List<TimeSlot> busySlots) {
        List<TimeSlot> freeSlots = new ArrayList<>();
        int currentTime = workStartMinutes;
        for (TimeSlot busySlot : busySlots) {
            if (currentTime < busySlot.startMinutes) {
                freeSlots.add(new TimeSlot(currentTime, busySlot.startMinutes));
            }
            currentTime = Math.max(currentTime, busySlot.endMinutes);
        }
        if (currentTime < workEndMinutes) {
            freeSlots.add(new TimeSlot(currentTime, workEndMinutes));
        }
        return freeSlots;
    }

    private void addToExistingSchedules(List<FixedSchedule> existingSchedules, Map<String, Object> newSlot,
            Integer breakTime) {
        FixedSchedule tempSchedule = new FixedSchedule();
        tempSchedule.setDayOfWeek((String) newSlot.get("dayOfWeek"));
        tempSchedule.setStartTime(LocalTime.parse((String) newSlot.get("startTime")));
        LocalTime endTime = LocalTime.parse((String) newSlot.get("endTime"));
        int breakMinutes = breakTime != null ? breakTime : 0;
        tempSchedule.setEndTime(endTime.plusMinutes(breakMinutes));
        existingSchedules.add(tempSchedule);
    }

    private Map<String, Object> createScheduleSuggestion(
            Task task, LocalDate date, int startMinutes, int endMinutes,
            Boolean useEDF, Boolean useGreedy) {
        Map<String, Object> suggestion = new HashMap<>();
        suggestion.put("taskTitle", task.getTitle());
        suggestion.put("taskDescription", task.getDescription());
        suggestion.put("dayOfWeek", date.toString());
        suggestion.put("startTime", minutesToTime(startMinutes));
        suggestion.put("endTime", minutesToTime(endMinutes));
        suggestion.put("priority", task.getPriority().name());
        suggestion.put("deadline", task.getDeadline().toString());
        suggestion.put("estimatedDuration", endMinutes - startMinutes);
        suggestion.put("algorithm",
                useEDF && useGreedy ? "EDF + Greedy" : useEDF ? "EDF" : useGreedy ? "Greedy" : "Default");
        return suggestion;
    }

    private int timeToMinutes(String time) {
        String[] parts = time.split(":");
        return Integer.parseInt(parts[0]) * 60 + Integer.parseInt(parts[1]);
    }

    private String minutesToTime(int minutes) {
        int hours = minutes / 60;
        int mins = minutes % 60;
        return String.format("%02d:%02d", hours, mins);
    }
}
