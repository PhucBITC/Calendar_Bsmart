package com.bsmart.domain;

public enum RepeatType {
    NONE("none", "No repeat"),
    DAILY("daily", "Daily"),
    WEEKLY("weekly", "Weekly"),
    MONTHLY("monthly", "Monthly"),
    YEARLY("yearly", "Yearly"),
    CUSTOM("custom", "Custom");
    
    private final String value;
    private final String displayName;
    
    RepeatType(String value, String displayName) {
        this.value = value;
        this.displayName = displayName;
    }
    
    public String getValue() {
        return value;
    }
    
    public String getDisplayName() {
        return displayName;
    }
    
    public static RepeatType fromValue(String value) {
        for (RepeatType type : RepeatType.values()) {
            if (type.value.equals(value)) {
                return type;
            }
        }
        return NONE; // Default
    }
}
