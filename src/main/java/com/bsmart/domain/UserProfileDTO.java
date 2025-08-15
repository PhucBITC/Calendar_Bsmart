package com.bsmart.domain;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;

public class UserProfileDTO {
    
    private Long id;
    
    @Size(min = 3, max = 50, message = "Username must be between 3-50 characters")
    private String username;
    
    @Email(message = "Invalid email format")
    private String email;
    
    @Size(max = 100, message = "Full name cannot exceed 100 characters")
    private String fullName;
    
    @Size(max = 20, message = "Phone number cannot exceed 20 characters")
    private String phoneNumber;
    
    private String avatarUrl;
    
    @Size(max = 500, message = "Bio cannot exceed 500 characters")
    private String bio;
    
    private String timezone;
    private String language;
    private Theme theme;
    
    // Notification settings
    private boolean notificationEnabled;
    private boolean emailNotificationEnabled;
    private boolean soundNotificationEnabled;
    private Integer notificationAdvanceMinutes;
    
    // Constructors
    public UserProfileDTO() {}
    
    public UserProfileDTO(User user) {
        this.id = user.getId();
        this.username = user.getUsername();
        this.email = user.getEmail();
        this.fullName = user.getFullName();
        this.phoneNumber = user.getPhoneNumber();
        this.avatarUrl = user.getAvatarUrl();
        this.bio = user.getBio();
        this.timezone = user.getTimezone();
        this.language = user.getLanguage();
        this.theme = user.getTheme();
        this.notificationEnabled = user.isNotificationEnabled();
        this.emailNotificationEnabled = user.isEmailNotificationEnabled();
        this.soundNotificationEnabled = user.isSoundNotificationEnabled();
        this.notificationAdvanceMinutes = user.getNotificationAdvanceMinutes();
    }
    
    // Getters and Setters
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getUsername() {
        return username;
    }
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getPhoneNumber() {
        return phoneNumber;
    }
    
    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    
    public String getAvatarUrl() {
        return avatarUrl;
    }
    
    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }
    
    public String getBio() {
        return bio;
    }
    
    public void setBio(String bio) {
        this.bio = bio;
    }
    
    public String getTimezone() {
        return timezone;
    }
    
    public void setTimezone(String timezone) {
        this.timezone = timezone;
    }
    
    public String getLanguage() {
        return language;
    }
    
    public void setLanguage(String language) {
        this.language = language;
    }
    
    public Theme getTheme() {
        return theme;
    }
    
    public void setTheme(Theme theme) {
        this.theme = theme;
    }
    
    public boolean isNotificationEnabled() {
        return notificationEnabled;
    }
    
    public void setNotificationEnabled(boolean notificationEnabled) {
        this.notificationEnabled = notificationEnabled;
    }
    
    public boolean isEmailNotificationEnabled() {
        return emailNotificationEnabled;
    }
    
    public void setEmailNotificationEnabled(boolean emailNotificationEnabled) {
        this.emailNotificationEnabled = emailNotificationEnabled;
    }
    
    public boolean isSoundNotificationEnabled() {
        return soundNotificationEnabled;
    }
    
    public void setSoundNotificationEnabled(boolean soundNotificationEnabled) {
        this.soundNotificationEnabled = soundNotificationEnabled;
    }
    
    public Integer getNotificationAdvanceMinutes() {
        return notificationAdvanceMinutes;
    }
    
    public void setNotificationAdvanceMinutes(Integer notificationAdvanceMinutes) {
        this.notificationAdvanceMinutes = notificationAdvanceMinutes;
    }
}
