package com.bsmart.service;

import com.bsmart.domain.FixedSchedule;
import com.bsmart.domain.GeneratedScheduleDTO;
import com.bsmart.domain.Task;
import com.bsmart.repository.FixedScheduleRepository;
import com.bsmart.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;
import com.bsmart.domain.User;

/**
 * Service xử lý lịch cố định và lập lịch tự động dựa trên thuật toán:
 * - EDF (Earliest Deadline First)
 * - Greedy (Ưu tiên cao)
 * - Interval Scheduling (Không trùng lịch)
 */
@Service
public class FixedScheduleService {

    @Autowired
    private FixedScheduleRepository fixedScheduleRepository;

    @Autowired
    private TaskRepository taskRepository;

    // Lấy tất cả lịch học cố định
    public List<FixedSchedule> getAllSchedules() {
        return fixedScheduleRepository.findAll();
    }

    // Lấy lịch theo user
    public List<FixedSchedule> getSchedulesByUser(User user) {
        return fixedScheduleRepository.findByUser(user);
    }

    // FixedScheduleService.java
    public FixedSchedule saveSchedule(FixedSchedule schedule) {
        return fixedScheduleRepository.save(schedule); // Return saved object với ID
    }

    // Lấy lịch theo ID
    public FixedSchedule getScheduleById(Long id) {
        return fixedScheduleRepository.findById(id).orElse(null);
    }

    // Xoá lịch
    public void deleteSchedule(Long id) {
        fixedScheduleRepository.deleteById(id);
    }
}
