package com.bsmart.domain;

public enum NotificationType {
    SCHEDULE_REMINDER("SCHEDULE_REMINDER", "Schedule Reminder"),
    TASK_REMINDER("TASK_REMINDER", "Task Reminder"),
    SCHEDULE_CREATED("SCHEDULE_CREATED", "Schedule Created"),
    SCHEDULE_UPDATED("SCHEDULE_UPDATED", "Schedule Updated"),
    SCHEDULE_DELETED("SCHEDULE_DELETED", "Schedule Deleted"),
    TASK_CREATED("TASK_CREATED", "Task Created"),
    TASK_UPDATED("TASK_UPDATED", "Task Updated"),
    TASK_DELETED("TASK_DELETED", "Task Deleted"),
    SYSTEM_MESSAGE("SYSTEM_MESSAGE", "System Message"),
    WELCOME("WELCOME", "Welcome Message");
    
    private final String value;
    private final String displayName;
    
    NotificationType(String value, String displayName) {
        this.value = value;
        this.displayName = displayName;
    }
    
    public String getValue() {
        return value;
    }
    
    public String getDisplayName() {
        return displayName;
    }
    
    public static NotificationType fromValue(String value) {
        for (NotificationType type : NotificationType.values()) {
            if (type.value.equals(value)) {
                return type;
            }
        }
        return SYSTEM_MESSAGE; // Default
    }
}
