package com.bsmart.controller.admin;

import com.bsmart.repository.UserRepository;
import com.bsmart.repository.TaskRepository;
import com.bsmart.repository.FixedScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private TaskRepository taskRepository;
    
    @Autowired
    private FixedScheduleRepository fixedScheduleRepository;
    
    @GetMapping("")
    public String dashboard(Model model) {
        // Lấy tổng số người dùng
        long totalUsers = userRepository.count();
        
        // Lấy tổng số công việc
        long totalTasks = taskRepository.count();
        
        // Lấy tổng số lịch
        long totalSchedules = fixedScheduleRepository.count();
        
        // Tính phần trăm thay đổi (so sánh với 30 ngày trước)
        LocalDateTime thirtyDaysAgo = LocalDateTime.now().minus(30, ChronoUnit.DAYS);
        
        // Đếm người dùng mới trong 30 ngày qua
        long newUsersThisMonth = userRepository.count();
        // Lưu ý: Cần thêm field createdAt vào User entity để tính chính xác
        
        // Đếm công việc mới trong 30 ngày qua
        long newTasksThisMonth = taskRepository.count();
        // Lưu ý: Cần thêm field createdAt vào Task entity để tính chính xác
        
        // Đếm lịch mới trong 30 ngày qua
        long newSchedulesThisMonth = fixedScheduleRepository.count();
        // Lưu ý: Cần thêm field createdAt vào FixedSchedule entity để tính chính xác
        
        // Tính phần trăm thay đổi (tạm thời sử dụng dữ liệu mẫu cho phần trăm)
        double userGrowthPercent = 12.0; // Sẽ tính toán thực tế khi có field createdAt
        double taskGrowthPercent = 5.0;
        double scheduleGrowthPercent = 8.0;
        double systemPerformance = 98.5;
        
        // Truyền dữ liệu vào model
        model.addAttribute("totalUsers", totalUsers);
        model.addAttribute("totalTasks", totalTasks);
        model.addAttribute("totalSchedules", totalSchedules);
        model.addAttribute("userGrowthPercent", userGrowthPercent);
        model.addAttribute("taskGrowthPercent", taskGrowthPercent);
        model.addAttribute("scheduleGrowthPercent", scheduleGrowthPercent);
        model.addAttribute("systemPerformance", systemPerformance);
        
        return "admin/dashboard";
    }
    
    // Thêm các mapping cho quản lý user, task, schedule ở đây
}