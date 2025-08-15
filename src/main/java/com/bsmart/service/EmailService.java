package com.bsmart.service;

import com.bsmart.domain.Notification;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {
    
    @Autowired
    private JavaMailSender mailSender;
    
    public void sendNotificationEmail(Notification notification) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(notification.getUser().getEmail());
        message.setSubject(notification.getTitle());
        message.setText(notification.getMessage());
        
        mailSender.send(message);
    }
    
    public void sendWelcomeEmail(String to, String username) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject("Welcome to B-Smart Calendar!");
        message.setText(String.format("Hello %s,\n\nWelcome to B-Smart Calendar! We're excited to help you manage your schedule efficiently.\n\nBest regards,\nB-Smart Team", username));
        
        mailSender.send(message);
    }
    
    public void sendScheduleReminderEmail(String to, String scheduleTitle, String startTime) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject("Schedule Reminder: " + scheduleTitle);
        message.setText(String.format("Your schedule '%s' starts at %s. Don't forget to prepare!\n\nBest regards,\nB-Smart Calendar", scheduleTitle, startTime));
        
        mailSender.send(message);
    }
    
    public void sendTaskReminderEmail(String to, String taskTitle, String deadline) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setSubject("Task Reminder: " + taskTitle);
        message.setText(String.format("Your task '%s' is due at %s. Please complete it on time!\n\nBest regards,\nB-Smart Calendar", taskTitle, deadline));
        
        mailSender.send(message);
    }
}
