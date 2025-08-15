package com.bsmart.repository;

import com.bsmart.domain.Notification;
import com.bsmart.domain.NotificationStatus;
import com.bsmart.domain.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    
    // Find notifications by user
    Page<Notification> findByUserOrderByCreatedAtDesc(User user, Pageable pageable);
    
    // Find unread notifications by user
    List<Notification> findByUserAndStatusOrderByCreatedAtDesc(User user, NotificationStatus status);
    
    // Count unread notifications by user
    long countByUserAndStatus(User user, NotificationStatus status);
    
    // Find notifications by user and type
    List<Notification> findByUserAndTypeOrderByCreatedAtDesc(User user, String type);
    
    // Find scheduled notifications that need to be sent
    @Query("SELECT n FROM Notification n WHERE n.status = 'SCHEDULED' AND n.scheduledTime <= :now")
    List<Notification> findScheduledNotificationsToSend(@Param("now") LocalDateTime now);
    
    // Find notifications by related entity
    List<Notification> findByRelatedEntityTypeAndRelatedEntityId(String entityType, Long entityId);
    
    // Mark notifications as read
    @Modifying
    @Query("UPDATE Notification n SET n.status = 'READ', n.readTime = :readTime WHERE n.user = :user AND n.status = 'UNREAD'")
    void markAllAsRead(@Param("user") User user, @Param("readTime") LocalDateTime readTime);
    
    // Mark specific notification as read
    @Modifying
    @Query("UPDATE Notification n SET n.status = 'READ', n.readTime = :readTime WHERE n.id = :id")
    void markAsRead(@Param("id") Long id, @Param("readTime") LocalDateTime readTime);
    
    // Delete old notifications
    @Modifying
    @Query("DELETE FROM Notification n WHERE n.createdAt < :cutoffDate")
    void deleteOldNotifications(@Param("cutoffDate") LocalDateTime cutoffDate);
    
    // Find notifications by user with pagination and status filter
    @Query("SELECT n FROM Notification n WHERE n.user = :user AND (:status IS NULL OR n.status = :status) ORDER BY n.createdAt DESC")
    Page<Notification> findByUserAndStatusOptional(@Param("user") User user, @Param("status") NotificationStatus status, Pageable pageable);
}
