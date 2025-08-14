package com.bsmart.controller.client;

import com.bsmart.domain.User;
import com.bsmart.domain.UserLoginDTO;
import com.bsmart.domain.UserRegistrationDTO;
import com.bsmart.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Controller
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private AuthenticationManager authenticationManager;

    /**
     * Trang chủ - redirect dựa trên trạng thái đăng nhập
     */
    @GetMapping("/")
    public String home(Principal principal) {
        if (principal != null) {
            return "redirect:/schedule/add";
        }
        return "redirect:/auth/login";
    }

    /**
     * Hiển thị trang đăng nhập
     */
    @GetMapping("/auth/login")
    public String showLoginForm(Model model,
            @RequestParam(value = "error", required = false) String error,
            @RequestParam(value = "logout", required = false) String logout) {

        if (error != null) {
            model.addAttribute("errorMessage", "Tên đăng nhập hoặc mật khẩu không đúng!");
        }

        if (logout != null) {
            model.addAttribute("successMessage", "Đăng xuất thành công!");
        }

        model.addAttribute("loginDTO", new UserLoginDTO());
        return "client/auth/login";
    }

    /**
     * Hiển thị trang đăng ký
     */
    @GetMapping("/auth/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("registrationDTO", new UserRegistrationDTO());
        return "client/auth/register";
    }

    /**
     * Xử lý đăng ký
     */
    @PostMapping("/auth/register")
    public String processRegistration(@Valid @ModelAttribute("registrationDTO") UserRegistrationDTO registrationDTO,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes) {

        // Kiểm tra validation errors
        if (bindingResult.hasErrors()) {
            return "client/auth/register";
        }

        try {
            // Đăng ký user
            User user = userService.registerUser(registrationDTO);

            // Tự động đăng nhập sau khi đăng ký thành công
            Authentication auth = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            registrationDTO.getUsername(),
                            registrationDTO.getPassword()));
            SecurityContextHolder.getContext().setAuthentication(auth);

            redirectAttributes.addFlashAttribute("successMessage",
                    "Đăng ký thành công! Chào mừng " + user.getUsername());

            return "redirect:/schedule/add";

        } catch (RuntimeException e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "client/auth/register";
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Có lỗi xảy ra trong quá trình đăng ký. Vui lòng thử lại.");
            return "client/auth/register";
        }
    }

    /**
     * Xử lý đăng xuất
     */
    @GetMapping("/auth/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response,
            RedirectAttributes redirectAttributes) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null) {
            new SecurityContextLogoutHandler().logout(request, response, auth);
        }

        redirectAttributes.addFlashAttribute("successMessage", "Đăng xuất thành công!");
        return "redirect:/auth/login";
    }

    /**
     * Trang hồ sơ cá nhân
     */
    @GetMapping("/auth/profile")
    public String showProfile(Model model, Principal principal) {
        if (principal != null) {
            User user = userService.getCurrentUser(principal.getName());
            model.addAttribute("user", user);
        }
        return "client/auth/profile";
    }

    /**
     * Cập nhật hồ sơ
     */
    @PostMapping("/auth/profile")
    public String updateProfile(@ModelAttribute("user") User user,
            Principal principal,
            RedirectAttributes redirectAttributes) {
        try {
            User currentUser = userService.getCurrentUser(principal.getName());

            // Cập nhật thông tin (không cho phép thay đổi username, email, password)
            currentUser.setFullName(user.getFullName());
            currentUser.setPhoneNumber(user.getPhoneNumber());

            userService.updateUser(currentUser);

            redirectAttributes.addFlashAttribute("successMessage", "Cập nhật thông tin thành công!");

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật thông tin.");
        }

        return "redirect:/auth/profile";
    }

    /**
     * API kiểm tra username có tồn tại
     */
    @GetMapping("/auth/api/check-username")
    @ResponseBody
    public boolean checkUsername(@RequestParam String username) {
        return userService.existsByUsername(username);
    }

    /**
     * API kiểm tra email có tồn tại
     */
    @GetMapping("/auth/api/check-email")
    @ResponseBody
    public boolean checkEmail(@RequestParam String email) {
        return userService.existsByEmail(email);
    }

    /**
     * API lấy thông tin user hiện tại
     */
    @GetMapping("/auth/api/current-user")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCurrentUser(Principal principal) {
        Map<String, Object> response = new HashMap<>();
        
        if (principal == null) {
            return ResponseEntity.status(401).body(response);
        }
        
        try {
            User user = userService.getCurrentUser(principal.getName());
            response.put("id", user.getId());
            response.put("username", user.getUsername());
            response.put("email", user.getEmail());
            response.put("fullName", user.getFullName());
            response.put("role", user.getRole().getValue());
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            response.put("error", e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }
}