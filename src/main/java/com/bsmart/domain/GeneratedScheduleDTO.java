package com.bsmart.domain;

public class GeneratedScheduleDTO {

    private String taskTitle; // Tên nhiệm vụ
    private String dayOfWeek; // Thứ mấy
    private String startTime; // Giờ bắt đầu
    private String endTime; // Giờ kết thúc
    private String priority; // Mức độ ưu tiên

    // Constructors
    public GeneratedScheduleDTO() {
    }

    public GeneratedScheduleDTO(String taskTitle, String dayOfWeek, String startTime, String endTime, String priority) {
        this.taskTitle = taskTitle;
        this.dayOfWeek = dayOfWeek;
        this.startTime = startTime;
        this.endTime = endTime;
        this.priority = priority;
    }

    // Getters and Setters
    public String getTaskTitle() {
        return taskTitle;
    }

    public void setTaskTitle(String taskTitle) {
        this.taskTitle = taskTitle;
    }

    public String getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(String dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }
}
