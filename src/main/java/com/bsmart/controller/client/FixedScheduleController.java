package com.bsmart.controller.client;

import com.bsmart.domain.FixedSchedule;
import com.bsmart.domain.User;
import com.bsmart.service.FixedScheduleService;
import com.bsmart.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import com.bsmart.domain.Task;
import com.bsmart.service.TaskService;

@Controller
@RequestMapping("/schedule")
public class FixedScheduleController {

    @Autowired
    private FixedScheduleService fixedScheduleService;
    
    @Autowired
    private UserService userService;

    @Autowired
    private TaskService taskService;

    // Hiển thị form thêm mới
    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("schedule", new FixedSchedule());
        return "client/schedule/lichmoi";
    }

    // Lưu hoặc cập nhật lịch (Web form - redirect)
    @PostMapping("/save")
    public String save(@ModelAttribute FixedSchedule schedule, HttpServletRequest request) {
        System.out.println("=== WEB SAVE ===");
        System.out.println("ID: " + schedule.getId());
        System.out.println("Description: " + schedule.getDescription());
        System.out.println("Day of Week: " + schedule.getDayOfWeek());
        System.out.println("Start Time: " + schedule.getStartTime());
        System.out.println("End Time: " + schedule.getEndTime());

        // Lấy user hiện tại từ session
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser != null) {
            schedule.setUser(currentUser);
            System.out.println("User ID assigned: " + currentUser.getId());
        } else {
            System.out.println("WARNING: No current user found in session!");
        }

        FixedSchedule savedSchedule = fixedScheduleService.saveSchedule(schedule);
        return "redirect:/schedule/list";
    }

    // API: Lưu hoặc cập nhật lịch (AJAX - trả về JSON)
    @PostMapping("/api/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveApi(@ModelAttribute FixedSchedule schedule, HttpServletRequest request) {
        try {
            System.out.println("=== API SAVE ===");
            System.out.println("ID: " + schedule.getId());
            System.out.println("Description: " + schedule.getDescription());
            System.out.println("Day of Week: " + schedule.getDayOfWeek());
            System.out.println("Start Time: " + schedule.getStartTime());
            System.out.println("End Time: " + schedule.getEndTime());

            // Xử lý thời gian nếu là String (từ smart schedule)
            if (schedule.getStartTime() == null) {
                String startTimeStr = request.getParameter("startTime");
                if (startTimeStr != null) {
                    schedule.setStartTime(stringToLocalTime(startTimeStr));
                    System.out.println("Converted startTime: " + startTimeStr + " -> " + schedule.getStartTime());
                }
            }
            
            if (schedule.getEndTime() == null) {
                String endTimeStr = request.getParameter("endTime");
                if (endTimeStr != null) {
                    schedule.setEndTime(stringToLocalTime(endTimeStr));
                    System.out.println("Converted endTime: " + endTimeStr + " -> " + schedule.getEndTime());
                }
            }

            // Lấy user hiện tại từ session
            User currentUser = (User) request.getSession().getAttribute("currentUser");
            if (currentUser != null) {
                schedule.setUser(currentUser);
                System.out.println("User ID assigned: " + currentUser.getId());
            } else {
                System.out.println("WARNING: No current user found in session!");
            }

            // Xử lý repeat options
            String repeatType = request.getParameter("repeatType");
            if (repeatType != null && !repeatType.equals("none")) {
                // Tạo nhiều schedules dựa trên repeat type
                List<FixedSchedule> schedules = createRepeatingSchedules(schedule, repeatType);
                List<Map<String, Object>> savedSchedules = new ArrayList<>();
                
                for (FixedSchedule repeatSchedule : schedules) {
                    FixedSchedule saved = fixedScheduleService.saveSchedule(repeatSchedule);
                    Map<String, Object> scheduleData = new HashMap<>();
                    scheduleData.put("id", saved.getId());
                    scheduleData.put("description", saved.getDescription());
                    scheduleData.put("dayOfWeek", saved.getDayOfWeek());
                    scheduleData.put("startTime", saved.getStartTime() != null ? saved.getStartTime().toString() : null);
                    scheduleData.put("endTime", saved.getEndTime() != null ? saved.getEndTime().toString() : null);
                    scheduleData.put("color", saved.getColor());
                    savedSchedules.add(scheduleData);
                }

                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "Schedules saved successfully");
                response.put("data", savedSchedules);
                response.put("isRepeating", true);

                return ResponseEntity.ok(response);
            } else {
                // Lưu schedule đơn lẻ
                FixedSchedule savedSchedule = fixedScheduleService.saveSchedule(schedule);

                // Tạo response object đơn giản để tránh lazy loading
                Map<String, Object> scheduleData = new HashMap<>();
                scheduleData.put("id", savedSchedule.getId());
                scheduleData.put("description", savedSchedule.getDescription());
                scheduleData.put("dayOfWeek", savedSchedule.getDayOfWeek());
                scheduleData.put("startTime", savedSchedule.getStartTime() != null ? savedSchedule.getStartTime().toString() : null);
                scheduleData.put("endTime", savedSchedule.getEndTime() != null ? savedSchedule.getEndTime().toString() : null);
                scheduleData.put("color", savedSchedule.getColor());

                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("message", "Schedule saved successfully");
                response.put("data", scheduleData);

                return ResponseEntity.ok(response);
            }
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Error saving schedule: " + e.getMessage());

            return ResponseEntity.badRequest().body(response);
        }
    }

    // Danh sách tất cả lịch cố định
    @GetMapping("/list")
    public String showList(Model model) {
        model.addAttribute("schedules", fixedScheduleService.getAllSchedules());
        return "client/schedule/list";
    }

    // Xóa lịch
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Long id) {
        fixedScheduleService.deleteSchedule(id);
        return "redirect:/schedule/list";
    }

    // API: Xóa lịch (AJAX)
    @DeleteMapping("/api/delete/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteApi(@PathVariable Long id) {
        try {
            fixedScheduleService.deleteSchedule(id);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Schedule deleted successfully");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Error deleting schedule: " + e.getMessage());

            return ResponseEntity.badRequest().body(response);
        }
    }

    // API: Sinh lịch tự động (EDF + Greedy)
    @PostMapping("/api/generate")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> generateSmartSchedule(@RequestBody Map<String, Object> request, HttpServletRequest httpRequest) {
        try {
            // Lấy user hiện tại
            User currentUser = (User) httpRequest.getSession().getAttribute("currentUser");
            if (currentUser == null) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "User not authenticated");
                return ResponseEntity.status(401).body(response);
            }

            String targetDate = (String) request.get("targetDate");
            String startHour = (String) request.get("startHour");
            String endHour = (String) request.get("endHour");
            Integer breakTime = (Integer) request.get("breakTime");
            Boolean useEDF = (Boolean) request.get("useEDF");
            Boolean useGreedy = (Boolean) request.get("useGreedy");

            // Lấy tất cả tasks của user
            List<Task> userTasks = taskService.getTasksByUser(currentUser);
            
            if (userTasks.isEmpty()) {
                Map<String, Object> response = new HashMap<>();
                response.put("success", true);
                response.put("data", new ArrayList<>());
                response.put("message", "No tasks found for scheduling");
                return ResponseEntity.ok(response);
            }

            // Chuyển đổi tasks thành schedule suggestions
            List<Map<String, Object>> scheduleSuggestions = generateScheduleSuggestions(
                userTasks, targetDate, startHour, endHour, breakTime, useEDF, useGreedy
            );

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", scheduleSuggestions);
            response.put("message", "Generated " + scheduleSuggestions.size() + " schedule suggestions");

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Error generating schedule: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // API: Sinh lịch tự động dựa trên thông tin task mới
    @PostMapping("/api/generate-task-schedule")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> generateTaskSchedule(@RequestBody Map<String, Object> request, HttpServletRequest httpRequest) {
        try {
            System.out.println("=== GENERATE TASK SCHEDULE API CALLED ===");
            System.out.println("Request: " + request);
            
            // Lấy user hiện tại
            User currentUser = (User) httpRequest.getSession().getAttribute("currentUser");
            if (currentUser == null) {
                System.out.println("ERROR: User not authenticated");
                Map<String, Object> response = new HashMap<>();
                response.put("success", false);
                response.put("message", "User not authenticated");
                return ResponseEntity.status(401).body(response);
            }
            
            System.out.println("Current user: " + currentUser.getUsername());

            String taskTitle = (String) request.get("taskTitle");
            String taskDescription = (String) request.get("taskDescription");
            String taskPriority = (String) request.get("taskPriority");
            String taskDeadline = (String) request.get("taskDeadline");
            Integer estimatedDuration = (Integer) request.get("estimatedDuration");
            Integer repeatCount = (Integer) request.get("repeatCount");
            String startHour = (String) request.get("startHour");
            String endHour = (String) request.get("endHour");
            Integer breakTime = (Integer) request.get("breakTime");
            Boolean useEDF = (Boolean) request.get("useEDF");
            Boolean useGreedy = (Boolean) request.get("useGreedy");
            
            System.out.println("Parsed parameters:");
            System.out.println("- taskTitle: " + taskTitle);
            System.out.println("- taskDeadline: " + taskDeadline);
            System.out.println("- useEDF: " + useEDF);
            System.out.println("- useGreedy: " + useGreedy);

            // Tạo task object để sử dụng trong thuật toán
            Task task = new Task();
            task.setTitle(taskTitle);
            task.setDescription(taskDescription);
            task.setPriority(Task.Priority.valueOf(taskPriority));
            task.setDeadline(LocalDate.parse(taskDeadline));
            task.setEstimatedDuration(estimatedDuration);
            task.setUser(currentUser);
            
            System.out.println("Task created successfully");

            // Sinh lịch dựa trên thông tin task
            List<Map<String, Object>> scheduleSuggestions = generateTaskBasedSchedule(
                task, repeatCount, startHour, endHour, breakTime, useEDF, useGreedy
            );
            
            System.out.println("Generated " + scheduleSuggestions.size() + " suggestions");

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("data", scheduleSuggestions);
            response.put("message", "Generated " + scheduleSuggestions.size() + " schedule suggestions");
            
            System.out.println("Response: " + response);

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            System.out.println("ERROR in generateTaskSchedule: " + e.getMessage());
            e.printStackTrace();
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Error generating schedule: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // Thuật toán sinh lịch tự động
    private List<Map<String, Object>> generateScheduleSuggestions(
            List<Task> tasks, String targetDate, String startHour, String endHour, 
            Integer breakTime, Boolean useEDF, Boolean useGreedy) {
        
        List<Map<String, Object>> suggestions = new ArrayList<>();
        
        // Chuyển đổi thời gian làm việc thành phút
        int workStartMinutes = timeToMinutes(startHour);
        int workEndMinutes = timeToMinutes(endHour);
        int availableMinutes = workEndMinutes - workStartMinutes;
        
        // Sắp xếp tasks theo thuật toán được chọn
        List<Task> sortedTasks = new ArrayList<>(tasks);
        
        if (useEDF && useGreedy) {
            // Kết hợp EDF và Greedy: ưu tiên deadline trước, sau đó ưu tiên cao
            sortedTasks.sort((t1, t2) -> {
                // So sánh deadline trước
                if (t1.getDeadline() != null && t2.getDeadline() != null) {
                    int deadlineCompare = t1.getDeadline().compareTo(t2.getDeadline());
                    if (deadlineCompare != 0) return deadlineCompare;
                }
                // Nếu deadline bằng nhau hoặc null, so sánh priority
                return t2.getPriority().ordinal() - t1.getPriority().ordinal();
            });
        } else if (useEDF) {
            // Chỉ dùng EDF: sắp xếp theo deadline
            sortedTasks.sort((t1, t2) -> {
                if (t1.getDeadline() == null && t2.getDeadline() == null) return 0;
                if (t1.getDeadline() == null) return 1;
                if (t2.getDeadline() == null) return -1;
                return t1.getDeadline().compareTo(t2.getDeadline());
            });
        } else if (useGreedy) {
            // Chỉ dùng Greedy: sắp xếp theo priority
            sortedTasks.sort((t1, t2) -> t2.getPriority().ordinal() - t1.getPriority().ordinal());
        }
        
        // Phân bổ thời gian cho tasks
        int currentTime = workStartMinutes;
        
        for (Task task : sortedTasks) {
            if (currentTime >= workEndMinutes) break;
            
            // Ước tính thời gian cho task (dựa trên priority hoặc mặc định 60 phút)
            int taskDuration = estimateTaskDuration(task);
            
            // Kiểm tra xem có đủ thời gian không
            if (currentTime + taskDuration <= workEndMinutes) {
                Map<String, Object> suggestion = new HashMap<>();
                suggestion.put("taskTitle", task.getTitle());
                suggestion.put("dayOfWeek", targetDate);
                suggestion.put("startTime", minutesToTime(currentTime));
                suggestion.put("endTime", minutesToTime(currentTime + taskDuration));
                suggestion.put("priority", task.getPriority().name());
                suggestion.put("algorithm", useEDF && useGreedy ? "EDF + Greedy" : 
                             useEDF ? "EDF" : useGreedy ? "Greedy" : "Default");
                
                suggestions.add(suggestion);
                
                // Cập nhật thời gian hiện tại (bao gồm break time)
                currentTime += taskDuration + breakTime;
            }
        }
        
        return suggestions;
    }
    
    // Thuật toán sinh lịch tự động dựa trên task mới
    private List<Map<String, Object>> generateTaskBasedSchedule(
            Task task, Integer repeatCount, String startHour, String endHour, 
            Integer breakTime, Boolean useEDF, Boolean useGreedy) {
        
        List<Map<String, Object>> suggestions = new ArrayList<>();
        
        // Chuyển đổi thời gian làm việc thành phút
        int workStartMinutes = timeToMinutes(startHour);
        int workEndMinutes = timeToMinutes(endHour);
        int availableMinutes = workEndMinutes - workStartMinutes;
        
        // Tính toán thời gian cho task
        int taskDuration = task.getEstimatedDuration() != null ? task.getEstimatedDuration() : 60;
        
        // Kiểm tra xem có đủ thời gian không
        if (taskDuration > availableMinutes) {
            // Nếu task quá dài, chia nhỏ thành nhiều phần
            int parts = (int) Math.ceil((double) taskDuration / availableMinutes);
            taskDuration = availableMinutes;
            
            for (int i = 0; i < parts && i < repeatCount; i++) {
                Map<String, Object> suggestion = createScheduleSuggestion(task, i, taskDuration, workStartMinutes, workEndMinutes, useEDF, useGreedy);
                suggestions.add(suggestion);
            }
        } else {
            // Task vừa với thời gian có sẵn
            for (int i = 0; i < repeatCount; i++) {
                Map<String, Object> suggestion = createScheduleSuggestion(task, i, taskDuration, workStartMinutes, workEndMinutes, useEDF, useGreedy);
                suggestions.add(suggestion);
            }
        }
        
        return suggestions;
    }
    
    // Tạo suggestion cho một lần lặp
    private Map<String, Object> createScheduleSuggestion(Task task, int iteration, int duration, int workStart, int workEnd, Boolean useEDF, Boolean useGreedy) {
        Map<String, Object> suggestion = new HashMap<>();
        
        // Tính thời gian bắt đầu dựa trên thuật toán
        int startTime = calculateOptimalStartTime(task, iteration, duration, workStart, workEnd, useEDF, useGreedy);
        
        suggestion.put("taskTitle", task.getTitle());
        suggestion.put("taskDescription", task.getDescription());
        suggestion.put("dayOfWeek", calculateOptimalDate(task, iteration));
        suggestion.put("startTime", minutesToTime(startTime));
        suggestion.put("endTime", minutesToTime(startTime + duration));
        suggestion.put("priority", task.getPriority().name());
        suggestion.put("deadline", task.getDeadline().toString());
        suggestion.put("estimatedDuration", duration);
        suggestion.put("algorithm", useEDF && useGreedy ? "EDF + Greedy" : 
                     useEDF ? "EDF" : useGreedy ? "Greedy" : "Default");
        
        return suggestion;
    }
    
    // Tính thời gian bắt đầu tối ưu
    private int calculateOptimalStartTime(Task task, int iteration, int duration, int workStart, int workEnd, Boolean useEDF, Boolean useGreedy) {
        // Logic đơn giản: phân bổ đều trong ngày
        int availableTime = workEnd - workStart;
        int startTime = workStart + (iteration * (availableTime / 3)); // Chia thành 3 khoảng
        
        // Đảm bảo không vượt quá thời gian làm việc
        if (startTime + duration > workEnd) {
            startTime = workStart; // Bắt đầu từ đầu nếu không đủ thời gian
        }
        
        return startTime;
    }
    
    // Tính ngày tối ưu
    private String calculateOptimalDate(Task task, int iteration) {
        LocalDate deadline = task.getDeadline();
        LocalDate today = LocalDate.now();
        
        // Nếu deadline trong tương lai, phân bổ từ hôm nay đến deadline
        if (deadline.isAfter(today)) {
            long daysBetween = java.time.temporal.ChronoUnit.DAYS.between(today, deadline);
            if (daysBetween > 0) {
                LocalDate optimalDate = today.plusDays(iteration % (int) daysBetween);
                return optimalDate.toString();
            }
        }
        
        // Fallback: bắt đầu từ hôm nay
        return today.plusDays(iteration).toString();
    }

    // Chuyển đổi thời gian thành phút
    private int timeToMinutes(String time) {
        String[] parts = time.split(":");
        return Integer.parseInt(parts[0]) * 60 + Integer.parseInt(parts[1]);
    }
    
    // Chuyển đổi phút thành thời gian
    private String minutesToTime(int minutes) {
        int hours = minutes / 60;
        int mins = minutes % 60;
        return String.format("%02d:%02d", hours, mins);
    }
    
    // Chuyển đổi String thời gian thành LocalTime
    private LocalTime stringToLocalTime(String timeString) {
        if (timeString == null || timeString.trim().isEmpty()) {
            return LocalTime.of(0, 0); // Default to 00:00
        }
        try {
            return LocalTime.parse(timeString);
        } catch (Exception e) {
            System.out.println("Error parsing time: " + timeString + ", using default 00:00");
            return LocalTime.of(0, 0);
        }
    }
    
    // Ước tính thời gian cho task dựa trên priority
    private int estimateTaskDuration(Task task) {
        switch (task.getPriority()) {
            case HIGH:
                return 90; // 1.5 giờ
            case MEDIUM:
                return 60; // 1 giờ
            case LOW:
                return 30; // 30 phút
            default:
                return 60; // Mặc định 1 giờ
        }
    }

    // API: Xóa lịch (POST - cho frontend compatibility)
    @PostMapping("/api/delete/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteApiPost(@PathVariable Long id) {
        try {
            fixedScheduleService.deleteSchedule(id);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Schedule deleted successfully");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("message", "Error deleting schedule: " + e.getMessage());

            return ResponseEntity.badRequest().body(response);
        }
    }

    // Sửa lịch (load dữ liệu lên form)
    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Model model) {
        FixedSchedule schedule = fixedScheduleService.getScheduleById(id);
        if (schedule == null) {
            return "redirect:/schedule/list";
        }
        model.addAttribute("schedule", schedule);
        return "client/schedule/lichmoi";
    }

    // API: Lấy tất cả lịch (JSON)
    @GetMapping("/api/schedules")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getSchedulesApi(HttpServletRequest request) {
        // Lấy user hiện tại từ session
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser != null) {
            // Chỉ lấy schedules của user hiện tại
            List<FixedSchedule> schedules = fixedScheduleService.getSchedulesByUser(currentUser);
            
            // Chuyển đổi thành Map để tránh lazy loading
            List<Map<String, Object>> scheduleList = schedules.stream()
                .map(schedule -> {
                    Map<String, Object> scheduleMap = new HashMap<>();
                    scheduleMap.put("id", schedule.getId());
                    scheduleMap.put("description", schedule.getDescription());
                    scheduleMap.put("dayOfWeek", schedule.getDayOfWeek());
                    scheduleMap.put("startTime", schedule.getStartTime() != null ? schedule.getStartTime().toString() : null);
                    scheduleMap.put("endTime", schedule.getEndTime() != null ? schedule.getEndTime().toString() : null);
                    scheduleMap.put("color", schedule.getColor());
                    return scheduleMap;
                })
                .toList();
            
            return ResponseEntity.ok(scheduleList);
        } else {
            // Nếu không có user, trả về danh sách rỗng
            return ResponseEntity.ok(List.of());
        }
    }

    // API: Lấy lịch theo ID (JSON)
    @GetMapping("/api/schedule/{id}")
    @ResponseBody
    public ResponseEntity<FixedSchedule> getScheduleApi(@PathVariable Long id) {
        FixedSchedule schedule = fixedScheduleService.getScheduleById(id);
        if (schedule == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(schedule);
    }

    // Tạo repeating schedules dựa trên repeat type
    private List<FixedSchedule> createRepeatingSchedules(FixedSchedule originalSchedule, String repeatType) {
        List<FixedSchedule> schedules = new ArrayList<>();
        LocalDate startDate = LocalDate.parse(originalSchedule.getDayOfWeek());
        
        switch (repeatType) {
            case "daily":
                // Tạo schedule cho 7 ngày tiếp theo
                for (int i = 0; i < 7; i++) {
                    LocalDate date = startDate.plusDays(i);
                    FixedSchedule schedule = cloneSchedule(originalSchedule);
                    schedule.setDayOfWeek(date.toString());
                    schedules.add(schedule);
                }
                break;
                
            case "weekly":
                // Tạo schedule cho 4 tuần tiếp theo
                for (int i = 0; i < 4; i++) {
                    LocalDate date = startDate.plusWeeks(i);
                    FixedSchedule schedule = cloneSchedule(originalSchedule);
                    schedule.setDayOfWeek(date.toString());
                    schedules.add(schedule);
                }
                break;
                
            case "monthly":
                // Tạo schedule cho 3 tháng tiếp theo
                for (int i = 0; i < 3; i++) {
                    LocalDate date = startDate.plusMonths(i);
                    FixedSchedule schedule = cloneSchedule(originalSchedule);
                    schedule.setDayOfWeek(date.toString());
                    schedules.add(schedule);
                }
                break;
        }
        
        return schedules;
    }
    
    // Clone schedule object
    private FixedSchedule cloneSchedule(FixedSchedule original) {
        FixedSchedule clone = new FixedSchedule();
        clone.setDescription(original.getDescription());
        clone.setStartTime(original.getStartTime());
        clone.setEndTime(original.getEndTime());
        clone.setColor(original.getColor());
        clone.setUser(original.getUser());
        return clone;
    }
}