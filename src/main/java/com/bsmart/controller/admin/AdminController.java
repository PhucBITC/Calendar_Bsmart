package com.bsmart.controller.admin;

import com.bsmart.domain.User;
import com.bsmart.domain.UserRole;
import com.bsmart.service.AdminService;
import com.bsmart.service.NotificationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {
    
    @Autowired
    private AdminService adminService;
    
    @Autowired
    private NotificationService notificationService;
    
    // Check admin access
    private boolean isAdmin(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        return currentUser != null && UserRole.ADMIN.equals(currentUser.getRole());
    }
    
    // Dashboard
    @GetMapping
    public String dashboard(HttpSession session, Model model) {
        if (!isAdmin(session)) {
            return "redirect:/auth/login";
        }
        
        Map<String, Object> stats = adminService.getSystemStatistics();
        Map<String, Object> health = adminService.getSystemHealth();
        
        model.addAttribute("stats", stats);
        model.addAttribute("health", health);
        
        return "admin/dashboard";
    }
    
    // User Management
    @GetMapping("/users")
    public String userManagement(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "id") String sort,
            @RequestParam(required = false) String search,
            HttpSession session,
            Model model) {
        
        if (!isAdmin(session)) {
            return "redirect:/auth/login";
        }
        
        Pageable pageable = PageRequest.of(page, size, Sort.by(sort));
        Page<User> users;
        
        if (search != null && !search.trim().isEmpty()) {
            users = adminService.searchUsers(search, pageable);
        } else {
            users = adminService.getAllUsers(pageable);
        }
        
        model.addAttribute("users", users);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", users.getTotalPages());
        model.addAttribute("search", search);
        
        return "admin/users";
    }
    
    // Update user role
    @PostMapping("/users/{userId}/role")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateUserRole(
            @PathVariable Long userId,
            @RequestParam UserRole role,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        if (!isAdmin(session)) {
            response.put("success", false);
            response.put("message", "Access denied");
            return ResponseEntity.status(403).body(response);
        }
        
        try {
            User updatedUser = adminService.updateUserRole(userId, role);
            response.put("success", true);
            response.put("message", "User role updated successfully");
            response.put("user", updatedUser);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    // Activate user
    @PostMapping("/users/{userId}/activate")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> activateUser(
            @PathVariable Long userId,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        if (!isAdmin(session)) {
            response.put("success", false);
            response.put("message", "Access denied");
            return ResponseEntity.status(403).body(response);
        }
        
        try {
            adminService.activateUser(userId);
            response.put("success", true);
            response.put("message", "User activated successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    // Deactivate user
    @PostMapping("/users/{userId}/deactivate")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deactivateUser(
            @PathVariable Long userId,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        if (!isAdmin(session)) {
            response.put("success", false);
            response.put("message", "Access denied");
            return ResponseEntity.status(403).body(response);
        }
        
        try {
            adminService.deactivateUser(userId);
            response.put("success", true);
            response.put("message", "User deactivated successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    // Delete user
    @DeleteMapping("/users/{userId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteUser(
            @PathVariable Long userId,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        if (!isAdmin(session)) {
            response.put("success", false);
            response.put("message", "Access denied");
            return ResponseEntity.status(403).body(response);
        }
        
        try {
            adminService.deleteUser(userId);
            response.put("success", true);
            response.put("message", "User deleted successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    // System Statistics API
    @GetMapping("/api/stats")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getStats(HttpSession session) {
        if (!isAdmin(session)) {
            return ResponseEntity.status(403).build();
        }
        
        Map<String, Object> stats = adminService.getSystemStatistics();
        return ResponseEntity.ok(stats);
    }
    
    // System Health API
    @GetMapping("/api/health")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getHealth(HttpSession session) {
        if (!isAdmin(session)) {
            return ResponseEntity.status(403).build();
        }
        
        Map<String, Object> health = adminService.getSystemHealth();
        return ResponseEntity.ok(health);
    }
    
    // Send system notification
    @PostMapping("/notifications/send")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> sendSystemNotification(
            @RequestParam String title,
            @RequestParam String message,
            @RequestParam(required = false) List<Long> userIds,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        if (!isAdmin(session)) {
            response.put("success", false);
            response.put("message", "Access denied");
            return ResponseEntity.status(403).body(response);
        }
        
        try {
            if (userIds != null && !userIds.isEmpty()) {
                adminService.sendSystemNotification(title, message, userIds);
            } else {
                adminService.sendSystemNotificationToAllUsers(title, message);
            }
            
            response.put("success", true);
            response.put("message", "Notification sent successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    // Cleanup old data
    @PostMapping("/maintenance/cleanup")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> cleanupOldData(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        if (!isAdmin(session)) {
            response.put("success", false);
            response.put("message", "Access denied");
            return ResponseEntity.status(403).body(response);
        }
        
        try {
            adminService.cleanupOldData();
            response.put("success", true);
            response.put("message", "Cleanup completed successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    // Export data
    @GetMapping("/export/users")
    @ResponseBody
    public ResponseEntity<List<User>> exportUsers(HttpSession session) {
        if (!isAdmin(session)) {
            return ResponseEntity.status(403).build();
        }
        
        List<User> users = adminService.exportAllUsers();
        return ResponseEntity.ok(users);
    }
    
    // Get recently active users
    @GetMapping("/api/users/recent")
    @ResponseBody
    public ResponseEntity<List<User>> getRecentlyActiveUsers(
            @RequestParam(defaultValue = "10") int limit,
            HttpSession session) {
        
        if (!isAdmin(session)) {
            return ResponseEntity.status(403).build();
        }
        
        List<User> users = adminService.getRecentlyActiveUsers(limit);
        return ResponseEntity.ok(users);
    }
    
    // Get inactive users
    @GetMapping("/api/users/inactive")
    @ResponseBody
    public ResponseEntity<List<User>> getInactiveUsers(
            @RequestParam(defaultValue = "30") int days,
            HttpSession session) {
        
        if (!isAdmin(session)) {
            return ResponseEntity.status(403).build();
        }
        
        List<User> users = adminService.getInactiveUsers(days);
        return ResponseEntity.ok(users);
    }
}