package com.bsmart.controller.client;

import com.bsmart.domain.FixedSchedule;
import com.bsmart.domain.FixedScheduleDTO;
import com.bsmart.service.FixedScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/schedule")
public class FixedScheduleController {

    @Autowired
    private FixedScheduleService fixedScheduleService;

    // Hiển thị form thêm mới
    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("schedule", new FixedSchedule());
        return "client/schedule/lichmoi_new";
    }

    // Lưu hoặc cập nhật lịch (Web form - redirect)
    @PostMapping("/save")
    public String save(@ModelAttribute FixedSchedule schedule, Principal principal) {
        System.out.println("=== WEB SAVE ===");
        System.out.println("ID: " + schedule.getId());
        System.out.println("Description: " + schedule.getDescription());
        System.out.println("Day of Week: " + schedule.getDayOfWeek());
        System.out.println("Start Time: " + schedule.getStartTime());
        System.out.println("End Time: " + schedule.getEndTime());

        if (principal != null) {
            FixedSchedule savedSchedule = fixedScheduleService.saveSchedule(schedule, principal.getName());
        } else {
            FixedSchedule savedSchedule = fixedScheduleService.saveSchedule(schedule);
        }
        return "redirect:/schedule/list";
    }

    // API: Lưu hoặc cập nhật lịch (AJAX - trả về JSON)
    @PostMapping("/api/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveApi(@ModelAttribute FixedSchedule schedule, Principal principal) {
        try {
            System.out.println("=== API SAVE ===");
            System.out.println("ID: " + schedule.getId());
            System.out.println("Description: " + schedule.getDescription());
            System.out.println("Day of Week: " + schedule.getDayOfWeek());
            System.out.println("Start Time: " + schedule.getStartTime());
            System.out.println("End Time: " + schedule.getEndTime());

            FixedSchedule savedSchedule;
            if (principal != null) {
                savedSchedule = fixedScheduleService.saveSchedule(schedule, principal.getName());
            } else {
                savedSchedule = fixedScheduleService.saveSchedule(schedule);
            }

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Schedule saved successfully");
            response.put("data", FixedScheduleDTO.fromEntity(savedSchedule));

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
    public String showList(Model model, Principal principal) {
        if (principal != null) {
            model.addAttribute("schedules", fixedScheduleService.getSchedulesByUsername(principal.getName()));
        } else {
            model.addAttribute("schedules", fixedScheduleService.getAllSchedules());
        }
        return "client/schedule/list";
    }

    // Xóa lịch
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Long id, Principal principal) {
        if (principal != null && fixedScheduleService.isScheduleOwnedByUser(id, principal.getName())) {
            fixedScheduleService.deleteSchedule(id);
        }
        return "redirect:/schedule/list";
    }

    // API: Xóa lịch (AJAX)
    @DeleteMapping("/api/delete/{id}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteApi(@PathVariable Long id, Principal principal) {
        try {
            if (principal != null && fixedScheduleService.isScheduleOwnedByUser(id, principal.getName())) {
                fixedScheduleService.deleteSchedule(id);
            }

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
    public String edit(@PathVariable Long id, Model model, Principal principal) {
        if (principal != null && fixedScheduleService.isScheduleOwnedByUser(id, principal.getName())) {
            FixedSchedule schedule = fixedScheduleService.getScheduleById(id);
            if (schedule == null) {
                return "redirect:/schedule/list";
            }
            model.addAttribute("schedule", schedule);
            return "client/schedule/lichmoi";
        }
        return "redirect:/schedule/list";
    }

    // API: Lấy tất cả lịch (JSON)
    @GetMapping("/api/schedules")
    @ResponseBody
    public ResponseEntity<List<FixedScheduleDTO>> getSchedulesApi(Principal principal) {
        List<FixedSchedule> schedules;
        if (principal != null) {
            schedules = fixedScheduleService.getSchedulesByUsername(principal.getName());
        } else {
            schedules = fixedScheduleService.getAllSchedules();
        }
        return ResponseEntity.ok(schedules.stream().map(FixedScheduleDTO::fromEntity).toList());
    }

    // API: Lấy lịch theo ID (JSON)
    @GetMapping("/api/schedule/{id}")
    @ResponseBody
    public ResponseEntity<FixedScheduleDTO> getScheduleApi(@PathVariable Long id, Principal principal) {
        FixedSchedule schedule = fixedScheduleService.getScheduleById(id);
        if (schedule == null) {
            return ResponseEntity.notFound().build();
        }
        
        // Kiểm tra quyền truy cập
        if (principal != null && !fixedScheduleService.isScheduleOwnedByUser(id, principal.getName())) {
            return ResponseEntity.status(403).build(); // Forbidden
        }
        
        return ResponseEntity.ok(FixedScheduleDTO.fromEntity(schedule));
    }

    // Sinh lịch thông minh từ các task + khoảng trống của fixed schedule
    @PostMapping("/api/generate")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> generateSmartSchedule(Principal principal) {
        Map<String, Object> response = new HashMap<>();
        try {
            if (principal == null) {
                response.put("success", false);
                response.put("message", "Unauthorized");
                return ResponseEntity.status(401).body(response);
            }

            var result = fixedScheduleService.generateSmartSchedule(principal.getName());
            response.put("success", true);
            response.put("data", result);
            return ResponseEntity.ok(response);
        } catch (Exception ex) {
            response.put("success", false);
            response.put("message", ex.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}