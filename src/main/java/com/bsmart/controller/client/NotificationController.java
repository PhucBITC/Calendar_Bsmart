package com.bsmart.controller.client;

import com.bsmart.domain.Notification;
import com.bsmart.domain.User;
import com.bsmart.service.NotificationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/notifications")
public class NotificationController {
    
    @Autowired
    private NotificationService notificationService;
    
    // Show notifications page
    @GetMapping
    public String showNotifications(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            HttpSession session,
            Model model) {
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/auth/login";
        }
        
        Pageable pageable = PageRequest.of(page, size);
        Page<Notification> notifications = notificationService.getUserNotifications(currentUser, pageable);
        long unreadCount = notificationService.getUnreadCount(currentUser);
        
        model.addAttribute("notifications", notifications);
        model.addAttribute("unreadCount", unreadCount);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", notifications.getTotalPages());
        
        return "client/notifications/list";
    }
    
    // Get notifications API
    @GetMapping("/api")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getNotifications(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String status,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.put("success", false);
            response.put("message", "User not authenticated");
            return ResponseEntity.status(401).body(response);
        }
        
        try {
            Pageable pageable = PageRequest.of(page, size);
            Page<Notification> notifications;
            
            if (status != null && !status.isEmpty()) {
                notifications = notificationService.getUserNotificationsByStatus(
                    currentUser, 
                    com.bsmart.domain.NotificationStatus.fromValue(status), 
                    pageable
                );
            } else {
                notifications = notificationService.getUserNotifications(currentUser, pageable);
            }
            
            long unreadCount = notificationService.getUnreadCount(currentUser);
            
            response.put("success", true);
            response.put("notifications", notifications.getContent());
            response.put("unreadCount", unreadCount);
            response.put("totalPages", notifications.getTotalPages());
            response.put("currentPage", page);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    // Get unread notifications count
    @GetMapping("/api/unread-count")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getUnreadCount(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.put("success", false);
            response.put("message", "User not authenticated");
            return ResponseEntity.status(401).body(response);
        }
        
        try {
            long unreadCount = notificationService.getUnreadCount(currentUser);
            response.put("success", true);
            response.put("unreadCount", unreadCount);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    // Get unread notifications
    @GetMapping("/api/unread")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getUnreadNotifications(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.put("success", false);
            response.put("message", "User not authenticated");
            return ResponseEntity.status(401).body(response);
        }
        
        try {
            List<Notification> notifications = notificationService.getUnreadNotifications(currentUser);
            response.put("success", true);
            response.put("notifications", notifications);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    // Mark notification as read
    @PostMapping("/api/{notificationId}/read")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> markAsRead(
            @PathVariable Long notificationId,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.put("success", false);
            response.put("message", "User not authenticated");
            return ResponseEntity.status(401).body(response);
        }
        
        try {
            notificationService.markAsRead(notificationId);
            response.put("success", true);
            response.put("message", "Notification marked as read");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    // Mark all notifications as read
    @PostMapping("/api/mark-all-read")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> markAllAsRead(HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.put("success", false);
            response.put("message", "User not authenticated");
            return ResponseEntity.status(401).body(response);
        }
        
        try {
            notificationService.markAllAsRead(currentUser);
            response.put("success", true);
            response.put("message", "All notifications marked as read");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    // Delete notification
    @DeleteMapping("/api/{notificationId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteNotification(
            @PathVariable Long notificationId,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.put("success", false);
            response.put("message", "User not authenticated");
            return ResponseEntity.status(401).body(response);
        }
        
        try {
            notificationService.deleteNotification(notificationId);
            response.put("success", true);
            response.put("message", "Notification deleted successfully");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    // Get notification by ID
    @GetMapping("/api/{notificationId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getNotification(
            @PathVariable Long notificationId,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            response.put("success", false);
            response.put("message", "User not authenticated");
            return ResponseEntity.status(401).body(response);
        }
        
        try {
            java.util.Optional<Notification> notification = notificationService.getNotificationById(notificationId);
            if (notification.isPresent()) {
                response.put("success", true);
                response.put("notification", notification.get());
                return ResponseEntity.ok(response);
            } else {
                response.put("success", false);
                response.put("message", "Notification not found");
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}
