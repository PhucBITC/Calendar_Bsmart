package com.bsmart.controller.admin;

import com.bsmart.repository.UserRepository;
import com.bsmart.repository.TaskRepository;
import com.bsmart.repository.FixedScheduleRepository;
import com.bsmart.domain.User;
import com.bsmart.domain.UserRole;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;

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
    
    // ==================== USER MANAGEMENT ====================
    
    @GetMapping("/users")
    public String listUsers(Model model, 
                          @RequestParam(required = false) String search,
                          @RequestParam(required = false) String role,
                          @RequestParam(required = false) String status) {
        
        List<User> users;
        
        // Nếu có tham số tìm kiếm hoặc lọc
        if ((search != null && !search.trim().isEmpty()) || 
            (role != null && !role.trim().isEmpty()) || 
            (status != null && !status.trim().isEmpty())) {
            
            users = userRepository.findAll().stream()
                .filter(user -> {
                    // Lọc theo tìm kiếm
                    if (search != null && !search.trim().isEmpty()) {
                        String searchLower = search.toLowerCase();
                        boolean matchesSearch = user.getUsername().toLowerCase().contains(searchLower) ||
                                              user.getEmail().toLowerCase().contains(searchLower) ||
                                              (user.getFullName() != null && user.getFullName().toLowerCase().contains(searchLower));
                        if (!matchesSearch) return false;
                    }
                    
                    // Lọc theo role
                    if (role != null && !role.trim().isEmpty()) {
                        if (!user.getRole().name().equals(role)) return false;
                    }
                    
                    // Lọc theo status
                    if (status != null && !status.trim().isEmpty()) {
                        if (status.equals("active") && !user.isActive()) return false;
                        if (status.equals("inactive") && user.isActive()) return false;
                    }
                    
                    return true;
                })
                .collect(java.util.stream.Collectors.toList());
        } else {
            // Lấy tất cả users nếu không có tham số tìm kiếm
            users = userRepository.findAll();
        }
        
        model.addAttribute("users", users);
        return "admin/users/list";
    }
    
    @GetMapping("/users/add")
    public String addUserForm(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("roles", UserRole.values());
        return "admin/users/add";
    }
    
    @PostMapping("/users/add")
    public String addUser(@ModelAttribute User user, RedirectAttributes redirectAttributes) {
        try {
            // Kiểm tra username đã tồn tại
            if (userRepository.existsByUsername(user.getUsername())) {
                redirectAttributes.addFlashAttribute("error", "Username đã tồn tại!");
                return "redirect:/admin/users/add";
            }
            
            // Kiểm tra email đã tồn tại
            if (userRepository.existsByEmail(user.getEmail())) {
                redirectAttributes.addFlashAttribute("error", "Email đã tồn tại!");
                return "redirect:/admin/users/add";
            }
            
            // Set default values
            user.setActive(true);
            user.setCreatedAt(LocalDateTime.now());
            
            userRepository.save(user);
            redirectAttributes.addFlashAttribute("success", "Thêm người dùng thành công!");
            return "redirect:/admin/users";
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/admin/users/add";
        }
    }
    
    @GetMapping("/users/edit/{id}")
    public String editUserForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isPresent()) {
            model.addAttribute("user", userOpt.get());
            model.addAttribute("roles", UserRole.values());
            return "admin/users/edit";
        } else {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy người dùng!");
            return "redirect:/admin/users";
        }
    }
    
    @PostMapping("/users/edit/{id}")
    public String editUser(@PathVariable Long id, @ModelAttribute User user, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> existingUserOpt = userRepository.findById(id);
            if (!existingUserOpt.isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy người dùng!");
                return "redirect:/admin/users";
            }
            
            User existingUser = existingUserOpt.get();
            
            // Kiểm tra username đã tồn tại (trừ user hiện tại)
            if (!existingUser.getUsername().equals(user.getUsername()) && 
                userRepository.existsByUsername(user.getUsername())) {
                redirectAttributes.addFlashAttribute("error", "Username đã tồn tại!");
                return "redirect:/admin/users/edit/" + id;
            }
            
            // Kiểm tra email đã tồn tại (trừ user hiện tại)
            if (!existingUser.getEmail().equals(user.getEmail()) && 
                userRepository.existsByEmail(user.getEmail())) {
                redirectAttributes.addFlashAttribute("error", "Email đã tồn tại!");
                return "redirect:/admin/users/edit/" + id;
            }
            
            // Cập nhật thông tin
            existingUser.setUsername(user.getUsername());
            existingUser.setEmail(user.getEmail());
            existingUser.setFullName(user.getFullName());
            existingUser.setRole(user.getRole());
            existingUser.setActive(user.isActive());
            existingUser.setUpdatedAt(LocalDateTime.now());
            
            userRepository.save(existingUser);
            redirectAttributes.addFlashAttribute("success", "Cập nhật người dùng thành công!");
            return "redirect:/admin/users";
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/admin/users/edit/" + id;
        }
    }
    
    @GetMapping("/users/view/{id}")
    public String viewUser(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        Optional<User> userOpt = userRepository.findById(id);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            model.addAttribute("user", user);
            
            // Lấy số lượng tasks của user
            long taskCount = taskRepository.countByUser(user);
            model.addAttribute("taskCount", taskCount);
            
            // Lấy số lượng schedules của user
            long scheduleCount = fixedScheduleRepository.countByUser(user);
            model.addAttribute("scheduleCount", scheduleCount);
            
            return "admin/users/view";
        } else {
            redirectAttributes.addFlashAttribute("error", "Không tìm thấy người dùng!");
            return "redirect:/admin/users";
        }
    }
    
    @PostMapping("/users/delete/{id}")
    public String deleteUser(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = userRepository.findById(id);
            if (!userOpt.isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy người dùng!");
                return "redirect:/admin/users";
            }
            
            User user = userOpt.get();
            
            // Kiểm tra xem user có tasks hoặc schedules không
            long taskCount = taskRepository.countByUser(user);
            long scheduleCount = fixedScheduleRepository.countByUser(user);
            
            if (taskCount > 0 || scheduleCount > 0) {
                redirectAttributes.addFlashAttribute("error", 
                    "Không thể xóa người dùng vì đang có " + taskCount + " công việc và " + scheduleCount + " lịch!");
                return "redirect:/admin/users";
            }
            
            userRepository.delete(user);
            redirectAttributes.addFlashAttribute("success", "Xóa người dùng thành công!");
            return "redirect:/admin/users";
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/admin/users";
        }
    }
    
    @PostMapping("/users/toggle-status/{id}")
    public String toggleUserStatus(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            Optional<User> userOpt = userRepository.findById(id);
            if (!userOpt.isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Không tìm thấy người dùng!");
                return "redirect:/admin/users";
            }
            
            User user = userOpt.get();
            user.setActive(!user.isActive());
            user.setUpdatedAt(LocalDateTime.now());
            
            userRepository.save(user);
            
            String status = user.isActive() ? "kích hoạt" : "vô hiệu hóa";
            redirectAttributes.addFlashAttribute("success", "Đã " + status + " người dùng thành công!");
            return "redirect:/admin/users";
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            return "redirect:/admin/users";
        }
    }
    
    // Thêm các mapping cho quản lý task, schedule ở đây
}