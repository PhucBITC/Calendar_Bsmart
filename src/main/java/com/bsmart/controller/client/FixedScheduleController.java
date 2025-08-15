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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/schedule")
public class FixedScheduleController {

    @Autowired
    private FixedScheduleService fixedScheduleService;
    
    @Autowired
    private UserService userService;

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

            // Lấy user hiện tại từ session
            User currentUser = (User) request.getSession().getAttribute("currentUser");
            if (currentUser != null) {
                schedule.setUser(currentUser);
                System.out.println("User ID assigned: " + currentUser.getId());
            } else {
                System.out.println("WARNING: No current user found in session!");
            }

            FixedSchedule savedSchedule = fixedScheduleService.saveSchedule(schedule);

            // Tạo response object đơn giản để tránh lazy loading
            Map<String, Object> scheduleData = new HashMap<>();
            scheduleData.put("id", savedSchedule.getId());
            scheduleData.put("description", savedSchedule.getDescription());
            scheduleData.put("dayOfWeek", savedSchedule.getDayOfWeek());
            scheduleData.put("startTime", savedSchedule.getStartTime());
            scheduleData.put("endTime", savedSchedule.getEndTime());
            scheduleData.put("color", savedSchedule.getColor());

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Schedule saved successfully");
            response.put("data", scheduleData);

            return ResponseEntity.ok(response);
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
                    scheduleMap.put("startTime", schedule.getStartTime());
                    scheduleMap.put("endTime", schedule.getEndTime());
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
}