package com.bsmart.service;

import com.bsmart.domain.*;
import com.bsmart.repository.NotificationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class NotificationService {
    
    @Autowired
    private NotificationRepository notificationRepository;
    
    @Autowired
    private EmailService emailService;
    
    // Create notification
    public Notification createNotification(User user, String title, String message, 
                                        NotificationType type, String relatedEntityType, Long relatedEntityId) {
        Notification notification = new Notification(user, title, message, type);
        notification.setRelatedEntityType(relatedEntityType);
        notification.setRelatedEntityId(relatedEntityId);
        notification.setStatus(NotificationStatus.UNREAD);
        return notificationRepository.save(notification);
    }
    
    // Create scheduled notification
    public Notification createScheduledNotification(User user, String title, String message, 
                                                   NotificationType type, LocalDateTime scheduledTime,
                                                   String relatedEntityType, Long relatedEntityId) {
        Notification notification = new Notification(user, title, message, type);
        notification.setRelatedEntityType(relatedEntityType);
        notification.setRelatedEntityId(relatedEntityId);
        notification.setStatus(NotificationStatus.SCHEDULED);
        notification.setScheduledTime(scheduledTime);
        return notificationRepository.save(notification);
    }
    
    // Get user notifications with pagination
    public Page<Notification> getUserNotifications(User user, Pageable pageable) {
        return notificationRepository.findByUserOrderByCreatedAtDesc(user, pageable);
    }
    
    // Get user notifications with status filter
    public Page<Notification> getUserNotificationsByStatus(User user, NotificationStatus status, Pageable pageable) {
        return notificationRepository.findByUserAndStatusOptional(user, status, pageable);
    }
    
    // Get unread notifications count
    public long getUnreadCount(User user) {
        return notificationRepository.countByUserAndStatus(user, NotificationStatus.UNREAD);
    }
    
    // Get unread notifications
    public List<Notification> getUnreadNotifications(User user) {
        return notificationRepository.findByUserAndStatusOrderByCreatedAtDesc(user, NotificationStatus.UNREAD);
    }
    
    // Mark notification as read
    public void markAsRead(Long notificationId) {
        notificationRepository.markAsRead(notificationId, LocalDateTime.now());
    }
    
    // Mark all notifications as read
    public void markAllAsRead(User user) {
        notificationRepository.markAllAsRead(user, LocalDateTime.now());
    }
    
    // Delete notification
    public void deleteNotification(Long notificationId) {
        notificationRepository.deleteById(notificationId);
    }
    
    // Get notification by ID
    public Optional<Notification> getNotificationById(Long id) {
        return notificationRepository.findById(id);
    }
    
    // Create schedule reminder notification
    public void createScheduleReminder(FixedSchedule schedule) {
        User user = schedule.getUser();
        String title = "Schedule Reminder";
        String message = String.format("Your schedule '%s' starts in %d minutes", 
                                     schedule.getTitle(), user.getNotificationAdvanceMinutes());
        
        LocalDateTime reminderTime = schedule.getStartDate().atTime(schedule.getStartTime())
                .minusMinutes(user.getNotificationAdvanceMinutes().longValue());
        
        createScheduledNotification(user, title, message, NotificationType.SCHEDULE_REMINDER, 
                                  reminderTime, "FIXED_SCHEDULE", schedule.getId());
    }
    
    // Create task reminder notification
    public void createTaskReminder(Task task) {
        User user = task.getUser();
        String title = "Task Reminder";
        String message = String.format("Your task '%s' is due in %d minutes", 
                                     task.getTitle(), user.getNotificationAdvanceMinutes());
        
        LocalDateTime reminderTime = task.getDeadline().atStartOfDay().minusMinutes(user.getNotificationAdvanceMinutes().longValue());
        
        createScheduledNotification(user, title, message, NotificationType.TASK_REMINDER, 
                                  reminderTime, "TASK", task.getId());
    }
    
    // Create schedule created notification
    public void notifyScheduleCreated(FixedSchedule schedule) {
        User user = schedule.getUser();
        String title = "Schedule Created";
        String message = String.format("Your schedule '%s' has been created successfully", schedule.getTitle());
        
        createNotification(user, title, message, NotificationType.SCHEDULE_CREATED, 
                          "FIXED_SCHEDULE", schedule.getId());
    }
    
    // Create schedule deleted notification
    public void notifyScheduleDeleted(String scheduleTitle, User user) {
        String title = "Schedule Deleted";
        String message = String.format("Your schedule '%s' has been deleted", scheduleTitle);
        
        createNotification(user, title, message, NotificationType.SCHEDULE_DELETED, null, null);
    }
    
    // Process scheduled notifications (runs every minute)
    @Scheduled(fixedRate = 60000) // 1 minute
    public void processScheduledNotifications() {
        List<Notification> scheduledNotifications = notificationRepository.findScheduledNotificationsToSend(LocalDateTime.now());
        
        for (Notification notification : scheduledNotifications) {
            try {
                // Send email notification if enabled
                if (notification.getUser().isEmailNotificationEnabled()) {
                    emailService.sendNotificationEmail(notification);
                }
                
                // Update notification status
                notification.setStatus(NotificationStatus.SENT);
                notification.setSentTime(LocalDateTime.now());
                notificationRepository.save(notification);
                
            } catch (Exception e) {
                // Log error and mark as failed
                notification.setStatus(NotificationStatus.FAILED);
                notificationRepository.save(notification);
            }
        }
    }
    
    // Clean up old notifications (runs daily)
    @Scheduled(cron = "0 0 2 * * ?") // 2 AM daily
    public void cleanupOldNotifications() {
        LocalDateTime cutoffDate = LocalDateTime.now().minusDays(30); // Keep 30 days
        notificationRepository.deleteOldNotifications(cutoffDate);
    }
    
    // Delete notifications related to an entity
    public void deleteNotificationsForEntity(String entityType, Long entityId) {
        List<Notification> notifications = notificationRepository.findByRelatedEntityTypeAndRelatedEntityId(entityType, entityId);
        notificationRepository.deleteAll(notifications);
    }
}
