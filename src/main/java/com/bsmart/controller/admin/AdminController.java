package com.bsmart.controller.admin;

import com.bsmart.domain.User;
import com.bsmart.domain.FixedSchedule;
import com.bsmart.domain.UserRole;
import com.bsmart.repository.UserRepository;
import com.bsmart.repository.FixedScheduleRepository;
import com.bsmart.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private FixedScheduleRepository fixedScheduleRepository;

    @Autowired
    private TaskRepository taskRepository;

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        long userCount = userRepository.count();
        long scheduleCount = fixedScheduleRepository.count();
        long taskCount = taskRepository.count();
        
        // Thống kê theo role
        long adminCount = userRepository.countByRole(UserRole.ADMIN);
        long userRoleCount = userRepository.countByRole(UserRole.USER);
        
        model.addAttribute("userCount", userCount);
        model.addAttribute("scheduleCount", scheduleCount);
        model.addAttribute("taskCount", taskCount);
        model.addAttribute("adminCount", adminCount);
        model.addAttribute("userRoleCount", userRoleCount);
        
        return "admin/dashboard";
    }

    @GetMapping("/users")
    public String userManagement(Model model) {
        List<User> users = userRepository.findAll();
        model.addAttribute("users", users);
        return "admin/users";
    }

    @GetMapping("/schedules")
    public String scheduleManagement(Model model) {
        List<FixedSchedule> schedules = fixedScheduleRepository.findAll();
        List<User> users = userRepository.findAll();
        model.addAttribute("schedules", schedules);
        model.addAttribute("users", users);
        return "admin/schedules";
    }

    @PostMapping("/users/{id}/toggle-role")
    @ResponseBody
    public Map<String, Object> toggleUserRole(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            User user = userRepository.findById(id).orElse(null);
            if (user == null) {
                response.put("success", false);
                response.put("message", "User not found");
                return response;
            }
            
            // Toggle between USER and ADMIN
            if (UserRole.USER.equals(user.getRole())) {
                user.setRole(UserRole.ADMIN);
            } else {
                user.setRole(UserRole.USER);
            }
            
            userRepository.save(user);
            
            response.put("success", true);
            response.put("message", "Role updated successfully");
            response.put("newRole", user.getRole().getValue());
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error updating role: " + e.getMessage());
        }
        
        return response;
    }

    @DeleteMapping("/users/{id}")
    @ResponseBody
    public Map<String, Object> deleteUser(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            if (userRepository.existsById(id)) {
                userRepository.deleteById(id);
                response.put("success", true);
                response.put("message", "User deleted successfully");
            } else {
                response.put("success", false);
                response.put("message", "User not found");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error deleting user: " + e.getMessage());
        }
        
        return response;
    }

    @DeleteMapping("/schedules/{id}")
    @ResponseBody
    public Map<String, Object> deleteSchedule(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            if (fixedScheduleRepository.existsById(id)) {
                fixedScheduleRepository.deleteById(id);
                response.put("success", true);
                response.put("message", "Schedule deleted successfully");
            } else {
                response.put("success", false);
                response.put("message", "Schedule not found");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Error deleting schedule: " + e.getMessage());
        }
        
        return response;
    }

    @GetMapping("/stats")
    @ResponseBody
    public Map<String, Object> getStats() {
        Map<String, Object> stats = new HashMap<>();
        
        stats.put("totalUsers", userRepository.count());
        stats.put("totalSchedules", fixedScheduleRepository.count());
        stats.put("totalTasks", taskRepository.count());
        stats.put("adminUsers", userRepository.countByRole(UserRole.ADMIN));
        stats.put("regularUsers", userRepository.countByRole(UserRole.USER));
        
        return stats;
    }
}


