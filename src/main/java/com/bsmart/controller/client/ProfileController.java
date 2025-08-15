package com.bsmart.controller.client;

import com.bsmart.domain.User;
import com.bsmart.domain.UserProfileDTO;
import com.bsmart.service.ProfileService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/profile")
public class ProfileController {
    
    @Autowired
    private ProfileService profileService;
    
    // Show profile page
    @GetMapping
    public String showProfile(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/auth/login";
        }
        
        UserProfileDTO profileDTO = profileService.getUserProfile(currentUser.getId());
        model.addAttribute("profile", profileDTO);
        model.addAttribute("themes", com.bsmart.domain.Theme.values());
        
        return "client/profile/profile";
    }
    
    // Update profile
    @PostMapping("/update")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateProfile(
            @Valid @RequestBody UserProfileDTO profileDTO,
            BindingResult result,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        if (result.hasErrors()) {
            response.put("success", false);
            response.put("message", "Validation errors");
            response.put("errors", result.getAllErrors());
            return ResponseEntity.badRequest().body(response);
        }
        
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "User not authenticated");
                return ResponseEntity.status(401).body(response);
            }
            
            UserProfileDTO updatedProfile = profileService.updateProfile(currentUser.getId(), profileDTO);
            
            // Update session
            User updatedUser = profileService.getUserById(currentUser.getId()).orElse(currentUser);
            session.setAttribute("currentUser", updatedUser);
            
            response.put("success", true);
            response.put("message", "Profile updated successfully");
            response.put("profile", updatedProfile);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    // Upload avatar
    @PostMapping("/avatar")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> uploadAvatar(
            @RequestParam("avatar") MultipartFile file,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "User not authenticated");
                return ResponseEntity.status(401).body(response);
            }
            
            if (file.isEmpty()) {
                response.put("success", false);
                response.put("message", "Please select a file");
                return ResponseEntity.badRequest().body(response);
            }
            
            String avatarUrl = profileService.updateAvatar(currentUser.getId(), file);
            
            // Update session
            User updatedUser = profileService.getUserById(currentUser.getId()).orElse(currentUser);
            session.setAttribute("currentUser", updatedUser);
            
            response.put("success", true);
            response.put("message", "Avatar updated successfully");
            response.put("avatarUrl", avatarUrl);
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    // Change password
    @PostMapping("/change-password")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> changePassword(
            @RequestParam("currentPassword") String currentPassword,
            @RequestParam("newPassword") String newPassword,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "User not authenticated");
                return ResponseEntity.status(401).body(response);
            }
            
            profileService.changePassword(currentUser.getId(), currentPassword, newPassword);
            
            response.put("success", true);
            response.put("message", "Password changed successfully");
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    // Update email
    @PostMapping("/update-email")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateEmail(
            @RequestParam("newEmail") String newEmail,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "User not authenticated");
                return ResponseEntity.status(401).body(response);
            }
            
            profileService.updateEmail(currentUser.getId(), newEmail);
            
            // Update session
            User updatedUser = profileService.getUserById(currentUser.getId()).orElse(currentUser);
            session.setAttribute("currentUser", updatedUser);
            
            response.put("success", true);
            response.put("message", "Email updated successfully");
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    // Update username
    @PostMapping("/update-username")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> updateUsername(
            @RequestParam("newUsername") String newUsername,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "User not authenticated");
                return ResponseEntity.status(401).body(response);
            }
            
            profileService.updateUsername(currentUser.getId(), newUsername);
            
            // Update session
            User updatedUser = profileService.getUserById(currentUser.getId()).orElse(currentUser);
            session.setAttribute("currentUser", updatedUser);
            
            response.put("success", true);
            response.put("message", "Username updated successfully");
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
    
    // Delete account
    @PostMapping("/delete-account")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteAccount(
            @RequestParam("password") String password,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "User not authenticated");
                return ResponseEntity.status(401).body(response);
            }
            
            profileService.deleteAccount(currentUser.getId(), password);
            
            // Invalidate session
            session.invalidate();
            
            response.put("success", true);
            response.put("message", "Account deleted successfully");
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}
