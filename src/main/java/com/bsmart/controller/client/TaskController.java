package com.bsmart.controller.client;

import com.bsmart.domain.FixedSchedule;
import com.bsmart.domain.Task;
import com.bsmart.domain.User;
import com.bsmart.service.FixedScheduleService;
import com.bsmart.service.TaskService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/task")
public class TaskController {

    @Autowired
    private TaskService taskService;

    @Autowired
    private FixedScheduleService fixedScheduleService;

    // DTO for receiving generated schedules from the client
    public static class GeneratedScheduleDTO {
        private String taskTitle;
        private String description;
        private String dayOfWeek;
        private String startTime;
        private String endTime;
        private String color;
        private String priority;
        private String deadline;
        private Integer estimatedDuration;

        // Getters & Setters
        public String getTaskTitle() {
            return taskTitle;
        }

        public void setTaskTitle(String taskTitle) {
            this.taskTitle = taskTitle;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public String getDayOfWeek() {
            return dayOfWeek;
        }

        public void setDayOfWeek(String dayOfWeek) {
            this.dayOfWeek = dayOfWeek;
        }

        public String getStartTime() {
            return startTime;
        }

        public void setStartTime(String startTime) {
            this.startTime = startTime;
        }

        public String getEndTime() {
            return endTime;
        }

        public void setEndTime(String endTime) {
            this.endTime = endTime;
        }

        public String getColor() {
            return color;
        }

        public void setColor(String color) {
            this.color = color;
        }

        public String getPriority() {
            return priority;
        }

        public void setPriority(String priority) {
            this.priority = priority;
        }

        public String getDeadline() {
            return deadline;
        }

        public void setDeadline(String deadline) {
            this.deadline = deadline;
        }

        public Integer getEstimatedDuration() {
            return estimatedDuration;
        }

        public void setEstimatedDuration(Integer estimatedDuration) {
            this.estimatedDuration = estimatedDuration;
        }
    }

    // API: Apply generated schedules
    @PostMapping("/api/apply-schedules")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> applySchedules(@RequestBody List<GeneratedScheduleDTO> schedules,
            HttpServletRequest request) {
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            return ResponseEntity.status(401).body(createErrorResponse("User not authenticated"));
        }

        if (schedules == null || schedules.isEmpty()) {
            return ResponseEntity.badRequest().body(createErrorResponse("No schedules to apply."));
        }

        try {
            List<Task> savedTasks = new ArrayList<>();
            for (GeneratedScheduleDTO dto : schedules) {
                Task task = new Task();
                task.setUser(currentUser);
                task.setTitle(dto.getTaskTitle());
                task.setDescription(dto.getDescription());

                if (dto.getDeadline() != null && !dto.getDeadline().isEmpty()) {
                    task.setDeadline(LocalDate.parse(dto.getDeadline()));
                }

                if (dto.getPriority() != null && !dto.getPriority().isEmpty()) {
                    task.setPriority(Task.Priority.valueOf(dto.getPriority()));
                }

                task.setEstimatedDuration(dto.getEstimatedDuration());

                // Also save a corresponding FixedSchedule to block out the time
                FixedSchedule fixedSchedule = new FixedSchedule();
                fixedSchedule.setUser(currentUser);
                fixedSchedule.setDescription(dto.getTaskTitle()); // Or a more detailed description
                fixedSchedule.setDayOfWeek(dto.getDayOfWeek());
                fixedSchedule.setStartTime(stringToLocalTime(dto.getStartTime()));
                fixedSchedule.setEndTime(stringToLocalTime(dto.getEndTime()));
                fixedSchedule.setColor(dto.getColor());

                taskService.saveTask(task);
                fixedScheduleService.saveSchedule(fixedSchedule);

                savedTasks.add(task);
            }
            return ResponseEntity.ok(createSuccessResponse(savedTasks.size() + " tasks saved successfully.", null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(createErrorResponse("Error saving schedules: " + e.getMessage()));
        }
    }

    // API: Sinh lịch tự động dựa trên thông tin task mới
    @PostMapping("/api/generate-task-schedule")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> generateTaskSchedule(@RequestBody Map<String, Object> request,
            HttpServletRequest httpRequest) {
        try {
            User currentUser = (User) httpRequest.getSession().getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.status(401).body(createErrorResponse("User not authenticated"));
            }

            String taskTitle = (String) request.get("taskTitle");
            String taskDescription = (String) request.get("taskDescription");
            String taskPriority = (String) request.get("taskPriority");
            String taskDeadline = (String) request.get("taskDeadline");
            Integer estimatedDuration = (Integer) request.get("estimatedDuration");
            Integer repeatCount = (Integer) request.get("repeatCount");
            String startHour = (String) request.get("startHour");
            String endHour = (String) request.get("endHour");
            Integer breakTime = (Integer) request.get("breakTime");

            Task task = new Task();
            task.setTitle(taskTitle);
            task.setDescription(taskDescription);
            task.setPriority(Task.Priority.valueOf(taskPriority));
            task.setDeadline(LocalDate.parse(taskDeadline));
            task.setEstimatedDuration(estimatedDuration);
            task.setUser(currentUser);

            List<Map<String, Object>> scheduleSuggestions = generateTaskBasedSchedule(
                    task, repeatCount, startHour, endHour, breakTime, true, true);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", scheduleSuggestions);
            response.put("message", "Generated " + scheduleSuggestions.size() + " schedule suggestions");

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            return ResponseEntity.badRequest()
                    .body(createErrorResponse("Error generating schedule: " + e.getMessage()));
        }
    }

    // API: Save a new task from the auto-scheduler
    @PostMapping("/api/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveTask(@RequestBody Task task, HttpServletRequest request) {
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            return ResponseEntity.status(401).body(createErrorResponse("User not authenticated"));
        }

        try {
            task.setUser(currentUser);
            Task savedTask = taskService.saveTask(task);

            Map<String, Object> responseData = new HashMap<>();
            responseData.put("id", savedTask.getId());
            responseData.put("title", savedTask.getTitle());

            return ResponseEntity.ok(createSuccessResponse("Task saved successfully.", responseData));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(createErrorResponse("Error saving task: " + e.getMessage()));
        }
    }

    // --- Private Helper Methods ---

    private List<Map<String, Object>> generateTaskBasedSchedule(
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

    private static class TimeSlot {
        int startMinutes;
        int endMinutes;

        TimeSlot(int startMinutes, int endMinutes) {
            this.startMinutes = startMinutes;
            this.endMinutes = endMinutes;
        }
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

    private LocalTime stringToLocalTime(String timeString) {
        if (timeString == null || timeString.trim().isEmpty()) {
            return null;
        }
        try {
            return LocalTime.parse(timeString);
        } catch (Exception e) {
            return null;
        }
    }

    private Map<String, Object> createSuccessResponse(String message, Object data) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", message);
        if (data != null) {
            response.put("data", data);
        }
        return response;
    }

    private Map<String, Object> createErrorResponse(String message) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", false);
        response.put("message", message);
        return response;
    }
}