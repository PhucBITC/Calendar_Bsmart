package com.bsmart.domain;

public enum Theme {
    LIGHT("light", "Light Theme"),
    DARK("dark", "Dark Theme"),
    AUTO("auto", "Auto (System)");
    
    private final String value;
    private final String displayName;
    
    Theme(String value, String displayName) {
        this.value = value;
        this.displayName = displayName;
    }
    
    public String getValue() {
        return value;
    }
    
    public String getDisplayName() {
        return displayName;
    }
    
    public static Theme fromValue(String value) {
        for (Theme theme : Theme.values()) {
            if (theme.value.equals(value)) {
                return theme;
            }
        }
        return LIGHT; // Default
    }
}
