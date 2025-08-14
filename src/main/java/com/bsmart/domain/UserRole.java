package com.bsmart.domain;

public enum UserRole {
    ADMIN("ADMIN"),
    USER("USER");
    
    private final String value;
    
    UserRole(String value) {
        this.value = value;
    }
    
    public String getValue() {
        return value;
    }
    
    @Override
    public String toString() {
        return value;
    }
}