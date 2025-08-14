package com.bsmart.domain;

import java.time.LocalTime;

public class FixedScheduleDTO {

	private Long id;
	private String description;
	private String dayOfWeek; // yyyy-MM-dd (current UI semantics)
	private LocalTime startTime;
	private LocalTime endTime;
	private String color;

	public FixedScheduleDTO() {}

	public FixedScheduleDTO(Long id, String description, String dayOfWeek, LocalTime startTime, LocalTime endTime, String color) {
		this.id = id;
		this.description = description;
		this.dayOfWeek = dayOfWeek;
		this.startTime = startTime;
		this.endTime = endTime;
		this.color = color;
	}

	public static FixedScheduleDTO fromEntity(FixedSchedule e) {
		return new FixedScheduleDTO(
				e.getId(),
				e.getDescription(),
				e.getDayOfWeek(),
				e.getStartTime(),
				e.getEndTime(),
				e.getColor()
		);
	}

	public Long getId() { return id; }
	public void setId(Long id) { this.id = id; }

	public String getDescription() { return description; }
	public void setDescription(String description) { this.description = description; }

	public String getDayOfWeek() { return dayOfWeek; }
	public void setDayOfWeek(String dayOfWeek) { this.dayOfWeek = dayOfWeek; }

	public LocalTime getStartTime() { return startTime; }
	public void setStartTime(LocalTime startTime) { this.startTime = startTime; }

	public LocalTime getEndTime() { return endTime; }
	public void setEndTime(LocalTime endTime) { this.endTime = endTime; }

	public String getColor() { return color; }
	public void setColor(String color) { this.color = color; }
}


