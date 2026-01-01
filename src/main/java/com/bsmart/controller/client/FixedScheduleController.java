package com.bsmart.controller.client;

import com.bsmart.domain.FixedSchedule;
import com.bsmart.domain.User;
import com.bsmart.service.FixedScheduleService;
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
import java.util.stream.Collectors;
import com.bsmart.domain.Task;
import com.bsmart.service.TaskService;

@Controller
@RequestMapping("/schedule")
public class FixedScheduleController {

    @Autowired
    private FixedScheduleService fixedScheduleService;

    // Hiển thị form thêm mới
    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("schedule", new FixedSchedule());
        return "client/schedule/lichmoi";
    }

    // Hiển thị trang giới thiệu
    @GetMapping("/page")
    public String showInfoPage() {
        return "client/schedule/page";
    }

    // Lưu hoặc cập nhật lịch (Web form - redirect)
    @PostMapping("/save")
    public String save(@ModelAttribute FixedSchedule schedule, HttpServletRequest request) {
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser != null) {
            schedule.setUser(currentUser);
        } else {
            return "redirect:/login";
        }

        fixedScheduleService.saveSchedule(schedule);
        return "redirect:/schedule/list";
    }

    // API: Lưu hoặc cập nhật lịch (AJAX - trả về JSON)
    @PostMapping("/api/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveApi(@ModelAttribute FixedSchedule schedule,
            HttpServletRequest request) {
        try {
            if (schedule.getStartTime() == null) {
                String startTimeStr = request.getParameter("startTime");
                if (startTimeStr != null) {
                    schedule.setStartTime(stringToLocalTime(startTimeStr));
                }
            }

            if (schedule.getEndTime() == null) {
                String endTimeStr = request.getParameter("endTime");
                if (endTimeStr != null) {
                    schedule.setEndTime(stringToLocalTime(endTimeStr));
                }
            }

            User currentUser = (User) request.getSession().getAttribute("currentUser");
            if (currentUser == null) {
                return ResponseEntity.status(401).body(createErrorResponse("User not authenticated"));
            }
            schedule.setUser(currentUser);

            // Kiểm tra xem có phải là update hàng loạt không
            String updateMode = request.getParameter("updateMode");
            if (schedule.getId() != null && updateMode != null && !updateMode.equals("single") && !updateMode.isEmpty()) {
                return updateRepeatingSchedules(schedule, updateMode, currentUser);
            }

            String repeatType = request.getParameter("repeatType");
            if (repeatType != null && !repeatType.equals("none")) {
                return saveRepeatingSchedules(schedule, repeatType);
            } else {
                return saveSingleSchedule(schedule);
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(createErrorResponse("Error saving schedule: " + e.getMessage()));
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
            return ResponseEntity.ok(createSuccessResponse("Schedule deleted successfully", null));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(createErrorResponse("Error deleting schedule: " + e.getMessage()));
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
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            return ResponseEntity.ok(List.of());
        }

        List<FixedSchedule> schedules = fixedScheduleService.getSchedulesByUser(currentUser);
        List<Map<String, Object>> scheduleList = schedules.stream()
                .map(this::convertScheduleToMap)
                .collect(Collectors.toList());

        return ResponseEntity.ok(scheduleList);
    }

    // API: Lấy lịch theo ID (JSON)
    @GetMapping("/api/schedule/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getScheduleApi(@PathVariable Long id) {
        FixedSchedule schedule = fixedScheduleService.getScheduleById(id);
        if (schedule == null) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(convertScheduleToMap(schedule));
    }

    // --- Private Helper Methods ---

    private ResponseEntity<Map<String, Object>> saveSingleSchedule(FixedSchedule schedule) {
        FixedSchedule savedSchedule = fixedScheduleService.saveSchedule(schedule);
        Map<String, Object> scheduleData = convertScheduleToMap(savedSchedule);
        return ResponseEntity.ok(createSuccessResponse("Schedule saved successfully", scheduleData));
    }

    private ResponseEntity<Map<String, Object>> saveRepeatingSchedules(FixedSchedule schedule, String repeatType) {
        List<FixedSchedule> schedulesToCreate = createRepeatingSchedules(schedule, repeatType);
        List<Map<String, Object>> savedSchedulesData = new ArrayList<>();

        for (FixedSchedule repeatSchedule : schedulesToCreate) {
            FixedSchedule saved = fixedScheduleService.saveSchedule(repeatSchedule);
            savedSchedulesData.add(convertScheduleToMap(saved));
        }

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Schedules saved successfully");
        response.put("data", savedSchedulesData);
        response.put("isRepeating", true);

        return ResponseEntity.ok(response);
    }

    private ResponseEntity<Map<String, Object>> updateRepeatingSchedules(FixedSchedule newScheduleData, String updateMode, User user) {
        // 1. Lấy thông tin sự kiện gốc từ DB (trước khi bị sửa) để làm căn cứ tìm kiếm
        FixedSchedule originalEvent = fixedScheduleService.getScheduleById(newScheduleData.getId());
        if (originalEvent == null) {
            return ResponseEntity.badRequest().body(createErrorResponse("Original event not found"));
        }

        // 2. Lấy tất cả lịch của user để lọc
        List<FixedSchedule> allSchedules = fixedScheduleService.getSchedulesByUser(user);
        List<FixedSchedule> schedulesToUpdate = new ArrayList<>();

        // 3. Lọc các sự kiện liên quan dựa trên updateMode và thông tin CŨ (originalEvent)
        for (FixedSchedule s : allSchedules) {
            // Điều kiện cơ bản: Cùng tên, cùng giờ bắt đầu/kết thúc (so với dữ liệu cũ)
            boolean isMatch = s.getDescription().equals(originalEvent.getDescription()) &&
                              s.getStartTime().equals(originalEvent.getStartTime()) &&
                              s.getEndTime().equals(originalEvent.getEndTime());

            if (isMatch) {
                LocalDate date = LocalDate.parse(s.getDayOfWeek());
                LocalDate originalDate = LocalDate.parse(originalEvent.getDayOfWeek());
                boolean shouldUpdate = false;

                switch (updateMode) {
                    case "daily": shouldUpdate = true; break;
                    case "weekly": if (date.getDayOfWeek() == originalDate.getDayOfWeek()) shouldUpdate = true; break;
                    case "monthly": if (date.getDayOfMonth() == originalDate.getDayOfMonth()) shouldUpdate = true; break;
                }

                if (shouldUpdate) {
                    schedulesToUpdate.add(s);
                }
            }
        }

        // 4. Lưu tất cả với thông tin MỚI
        List<Map<String, Object>> savedData = new ArrayList<>();
        for (FixedSchedule s : schedulesToUpdate) {
            s.setDescription(newScheduleData.getDescription());
            s.setStartTime(newScheduleData.getStartTime());
            s.setEndTime(newScheduleData.getEndTime());
            s.setColor(newScheduleData.getColor());
            fixedScheduleService.saveSchedule(s);
            savedData.add(convertScheduleToMap(s));
        }

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Updated " + savedData.size() + " events successfully");
        response.put("data", savedData);
        response.put("isRepeating", true); // Báo cho client biết đây là update hàng loạt
        return ResponseEntity.ok(response);
    }

    private LocalTime stringToLocalTime(String timeString) {
        if (timeString == null || timeString.trim().isEmpty()) {
            return null;
        }
        try {
            return LocalTime.parse(timeString);
        } catch (Exception e) {
            return null; // Return null if parsing fails
        }
    }

    private List<FixedSchedule> createRepeatingSchedules(FixedSchedule originalSchedule, String repeatType) {
        List<FixedSchedule> schedules = new ArrayList<>();
        LocalDate startDate = LocalDate.parse(originalSchedule.getDayOfWeek());
        int repeatCount = 0;

        switch (repeatType) {
            case "daily":
                repeatCount = 7;
                break;
            case "weekly":
                repeatCount = 4;
                break;
            case "monthly":
                repeatCount = 3;
                break;
        }

        for (int i = 0; i < repeatCount; i++) {
            LocalDate date;
            switch (repeatType) {
                case "daily":
                    date = startDate.plusDays(i);
                    break;
                case "weekly":
                    date = startDate.plusWeeks(i);
                    break;
                case "monthly":
                    date = startDate.plusMonths(i);
                    break;
                default:
                    // If repeatType is unknown, skip this iteration
                    continue;
            }

            FixedSchedule clone = cloneScheduleForDate(originalSchedule, date);
            // FIX: Nếu là lần lặp đầu tiên (ngày gốc) và sự kiện gốc có ID (đang edit),
            // gán lại ID để thực hiện Update thay vì Insert mới.
            if (i == 0 && originalSchedule.getId() != null) {
                clone.setId(originalSchedule.getId());
            }
            schedules.add(clone);
        }
        return schedules;
    }

    private FixedSchedule cloneScheduleForDate(FixedSchedule original, LocalDate date) {
        FixedSchedule clone = new FixedSchedule();
        clone.setDescription(original.getDescription());
        clone.setStartTime(original.getStartTime());
        clone.setEndTime(original.getEndTime());
        clone.setColor(original.getColor());
        clone.setUser(original.getUser());
        clone.setDayOfWeek(date.toString());
        return clone;
    }

    private Map<String, Object> convertScheduleToMap(FixedSchedule schedule) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", schedule.getId());
        map.put("description", schedule.getDescription());
        map.put("dayOfWeek", schedule.getDayOfWeek());
        map.put("startTime", schedule.getStartTime() != null ? schedule.getStartTime().toString() : null);
        map.put("endTime", schedule.getEndTime() != null ? schedule.getEndTime().toString() : null);
        map.put("color", schedule.getColor());
        return map;
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