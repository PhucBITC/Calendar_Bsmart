package com.bsmart.domain;

public enum NotificationStatus {
    UNREAD("UNREAD", "Unread"),
    READ("READ", "Read"),
    SENT("SENT", "Sent"),
    FAILED("FAILED", "Failed"),
    SCHEDULED("SCHEDULED", "Scheduled");
    
    private final String value;
    private final String displayName;
    
    NotificationStatus(String value, String displayName) {
        this.value = value;
        this.displayName = displayName;
    }
    
    public String getValue() {
        return value;
    }
    
    public String getDisplayName() {
        return displayName;
    }
    
    public static NotificationStatus fromValue(String value) {
        for (NotificationStatus status : NotificationStatus.values()) {
            if (status.value.equals(value)) {
                return status;
            }
        }
        return UNREAD; // Default
    }
}
