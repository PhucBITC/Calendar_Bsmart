package com.bsmart.service;

import com.bsmart.domain.*;
import com.bsmart.repository.FixedScheduleRepository;
import com.bsmart.repository.NotificationRepository;
import com.bsmart.repository.TaskRepository;
import com.bsmart.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@Transactional
public class AdminService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private TaskRepository taskRepository;
    
    @Autowired
    private FixedScheduleRepository fixedScheduleRepository;
    
    @Autowired
    private NotificationRepository notificationRepository;
    
    @Autowired
    private NotificationService notificationService;
    
    // User Management
    public Page<User> getAllUsers(Pageable pageable) {
        return userRepository.findAll(pageable);
    }
    
    public Optional<User> getUserById(Long userId) {
        return userRepository.findById(userId);
    }
    
    public User updateUserRole(Long userId, UserRole role) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setRole(role);
            user.setUpdatedAt(LocalDateTime.now());
            return userRepository.save(user);
        }
        throw new RuntimeException("User not found");
    }
    
    public void activateUser(Long userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setActive(true);
            user.setUpdatedAt(LocalDateTime.now());
            userRepository.save(user);
        }
    }
    
    public void deactivateUser(Long userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setActive(false);
            user.setUpdatedAt(LocalDateTime.now());
            userRepository.save(user);
        }
    }
    
    public void deleteUser(Long userId) {
        // First delete all related data
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            
            // Delete notifications
            notificationService.deleteNotificationsForEntity("USER", userId);
            
            // Delete tasks
            List<Task> tasks = taskRepository.findByUser(user);
            taskRepository.deleteAll(tasks);
            
            // Delete schedules
            List<FixedSchedule> schedules = fixedScheduleRepository.findByUser(user);
            fixedScheduleRepository.deleteAll(schedules);
            
            // Finally delete user
            userRepository.delete(user);
        }
    }
    
    // System Statistics
    public Map<String, Object> getSystemStatistics() {
        Map<String, Object> stats = new HashMap<>();
        
        // User statistics
        long totalUsers = userRepository.count();
        long activeUsers = userRepository.countByIsActiveTrue();
        long inactiveUsers = userRepository.countByIsActiveFalse();
        
        stats.put("totalUsers", totalUsers);
        stats.put("activeUsers", activeUsers);
        stats.put("inactiveUsers", inactiveUsers);
        
        // Task statistics
        long totalTasks = taskRepository.count();
        long completedTasks = taskRepository.countByStatus("COMPLETED");
        long pendingTasks = taskRepository.countByStatus("PENDING");
        
        stats.put("totalTasks", totalTasks);
        stats.put("completedTasks", completedTasks);
        stats.put("pendingTasks", pendingTasks);
        
        // Schedule statistics
        long totalSchedules = fixedScheduleRepository.count();
        long activeSchedules = fixedScheduleRepository.countByIsActiveTrue();
        
        stats.put("totalSchedules", totalSchedules);
        stats.put("activeSchedules", activeSchedules);
        
        // Notification statistics
        long totalNotifications = notificationRepository.count();
        long unreadNotifications = notificationRepository.countByStatus(NotificationStatus.UNREAD);
        long sentNotifications = notificationRepository.countByStatus(NotificationStatus.SENT);
        
        stats.put("totalNotifications", totalNotifications);
        stats.put("unreadNotifications", unreadNotifications);
        stats.put("sentNotifications", sentNotifications);
        
        // Recent activity
        LocalDateTime lastWeek = LocalDateTime.now().minusWeeks(1);
        long newUsersThisWeek = userRepository.countByCreatedAtAfter(lastWeek);
        long newTasksThisWeek = taskRepository.countByCreatedAtAfter(lastWeek);
        long newSchedulesThisWeek = fixedScheduleRepository.countByCreatedAtAfter(lastWeek);
        
        stats.put("newUsersThisWeek", newUsersThisWeek);
        stats.put("newTasksThisWeek", newTasksThisWeek);
        stats.put("newSchedulesThisWeek", newSchedulesThisWeek);
        
        return stats;
    }
    
    // User Activity
    public List<User> getRecentlyActiveUsers(int limit) {
        LocalDateTime lastDay = LocalDateTime.now().minusDays(1);
        return userRepository.findByLastLoginAfterOrderByLastLoginDesc(lastDay, Pageable.ofSize(limit)).getContent();
    }
    
    public List<User> getInactiveUsers(int days) {
        LocalDateTime cutoff = LocalDateTime.now().minusDays(days);
        return userRepository.findByLastLoginBeforeOrLastLoginIsNull(cutoff);
    }
    
    // System Maintenance
    public void cleanupOldData() {
        // Clean up old notifications (older than 90 days)
        LocalDateTime notificationCutoff = LocalDateTime.now().minusDays(90);
        notificationRepository.deleteOldNotifications(notificationCutoff);
        
        // Clean up old tasks (completed tasks older than 1 year)
        LocalDateTime taskCutoff = LocalDateTime.now().minusYears(1);
        taskRepository.deleteOldCompletedTasks(taskCutoff);
    }
    
    // Bulk Operations
    public void sendSystemNotification(String title, String message, List<Long> userIds) {
        for (Long userId : userIds) {
            Optional<User> userOpt = userRepository.findById(userId);
            if (userOpt.isPresent()) {
                notificationService.createNotification(
                    userOpt.get(), 
                    title, 
                    message, 
                    NotificationType.SYSTEM_MESSAGE, 
                    null, 
                    null
                );
            }
        }
    }
    
    public void sendSystemNotificationToAllUsers(String title, String message) {
        List<User> allUsers = userRepository.findByIsActiveTrue();
        for (User user : allUsers) {
            notificationService.createNotification(
                user, 
                title, 
                message, 
                NotificationType.SYSTEM_MESSAGE, 
                null, 
                null
            );
        }
    }
    
    // User Search
    public Page<User> searchUsers(String keyword, Pageable pageable) {
        return userRepository.findByUsernameContainingOrEmailContainingOrFullNameContaining(
            keyword, keyword, keyword, pageable);
    }
    
    // Export Data
    public List<User> exportAllUsers() {
        return userRepository.findAll();
    }
    
    public List<Task> exportAllTasks() {
        return taskRepository.findAll();
    }
    
    public List<FixedSchedule> exportAllSchedules() {
        return fixedScheduleRepository.findAll();
    }
    
    // System Health Check
    public Map<String, Object> getSystemHealth() {
        Map<String, Object> health = new HashMap<>();
        
        try {
            // Check database connectivity
            long userCount = userRepository.count();
            health.put("database", "OK");
            health.put("userCount", userCount);
            
            // Check notification service
            long notificationCount = notificationRepository.count();
            health.put("notificationService", "OK");
            health.put("notificationCount", notificationCount);
            
            health.put("status", "HEALTHY");
            health.put("timestamp", LocalDateTime.now());
            
        } catch (Exception e) {
            health.put("status", "UNHEALTHY");
            health.put("error", e.getMessage());
            health.put("timestamp", LocalDateTime.now());
        }
        
        return health;
    }
}
