package com.bsmart.controller.client;

import com.bsmart.domain.User;
import com.bsmart.domain.UserLoginDTO;
import com.bsmart.domain.UserRegistrationDTO;
import com.bsmart.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
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
import java.util.Optional;
import org.springframework.http.ResponseEntity;
import java.util.Map;
import java.util.HashMap;

@Controller
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private AuthenticationManager authenticationManager;

    /**
     * Hiển thị trang đăng nhập
     */
    @GetMapping("/login")
    public String showLoginForm(Model model,
            @RequestParam(value = "error", required = false) String error,
            @RequestParam(value = "logout", required = false) String logout) {

        if (error != null) {
            model.addAttribute("errorMessage", "Incorrect username or password!");
        }

        if (logout != null) {
            model.addAttribute("successMessage", "Logout successful!");
        }

        model.addAttribute("loginDTO", new UserLoginDTO());
        return "client/auth/login";
    }

    /**
     * Hiển thị trang đăng ký
     */
    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("registrationDTO", new UserRegistrationDTO());
        return "client/auth/register";
    }

    /**
     * Xử lý đăng ký
     */
    @PostMapping("/register")
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
                    "Registration successful! Welcome" + user.getUsername());

            return "redirect:/auth/login";

        } catch (RuntimeException e) {
            model.addAttribute("errorMessage", e.getMessage());
            return "client/auth/register";
        } catch (Exception e) {
            model.addAttribute("errorMessage", "An error occurred during registration. Please try again.");
            return "client/auth/register";
        }
    }

    /**
     * Xử lý đăng nhập (POST)
     */
    @PostMapping("/login")
    public String processLogin(@ModelAttribute("loginDTO") UserLoginDTO loginDTO,
            HttpServletRequest request,
            Model model) {
        Optional<User> userOpt = userService.findByUsernameOrEmail(loginDTO.getUsername());

        if (userOpt.isPresent() && userService.checkPassword(userOpt.get(), loginDTO.getPassword())) {
            User user = userOpt.get();
            request.getSession().setAttribute("currentUser", user);
            return "redirect:/schedule/add"; // Sửa đường dẫn đúng
        } else {
            model.addAttribute("errorMessage", "Incorrect username or password!");
            return "client/auth/login";
        }
    }

    /**
     * Xử lý đăng xuất
     */
    @GetMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response,
            RedirectAttributes redirectAttributes) {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null) {
            new SecurityContextLogoutHandler().logout(request, response, auth);
        }

        redirectAttributes.addFlashAttribute("successMessage", "Logout successful!");
        return "redirect:/auth/login";
    }

    /**
     * Trang hồ sơ cá nhân
     */
    @GetMapping("/profile")
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
    @PostMapping("/profile")
    public String updateProfile(@ModelAttribute("user") User user,
            Principal principal,
            RedirectAttributes redirectAttributes) {
        try {
            User currentUser = userService.getCurrentUser(principal.getName());

            // Cập nhật thông tin (không cho phép thay đổi username, email, password)
            currentUser.setFullName(user.getFullName());
            currentUser.setPhoneNumber(user.getPhoneNumber());

            userService.updateUser(currentUser);

            redirectAttributes.addFlashAttribute("successMessage", "Profile updated successfully!");

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "An error occurred while updating the profile.");
        }

        return "redirect:/auth/profile";
    }

    /**
     * API kiểm tra username có tồn tại
     */
    @GetMapping("/api/check-username")
    @ResponseBody
    public boolean checkUsername(@RequestParam String username) {
        return userService.existsByUsername(username);
    }

    /**
     * API kiểm tra email có tồn tại
     */
    @GetMapping("/api/check-email")
    @ResponseBody
    public boolean checkEmail(@RequestParam String email) {
        return userService.existsByEmail(email);
    }

    /**
     * API lấy thông tin user hiện tại
     */
    @GetMapping("/api/current-user")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getCurrentUser(HttpServletRequest request) {
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser != null) {
            // Trả về thông tin user đơn giản để tránh lazy loading
            Map<String, Object> userData = new HashMap<>();
            userData.put("id", currentUser.getId());
            userData.put("username", currentUser.getUsername());
            userData.put("email", currentUser.getEmail());
            userData.put("fullName", currentUser.getFullName());
            userData.put("role", currentUser.getRole());
            return ResponseEntity.ok(userData);
        } else {
            return ResponseEntity.status(401).build(); // Unauthorized
        }
    }
}