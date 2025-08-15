package com.bsmart.service;

import com.bsmart.domain.User;
import com.bsmart.domain.UserProfileDTO;
import com.bsmart.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class ProfileService {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    private static final String UPLOAD_DIR = "uploads/avatars/";
    
    // Get user profile
    public UserProfileDTO getUserProfile(Long userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            return new UserProfileDTO(userOpt.get());
        }
        throw new RuntimeException("User not found");
    }
    
    // Update user profile
    public UserProfileDTO updateProfile(Long userId, UserProfileDTO profileDTO) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            
            // Update basic info
            if (profileDTO.getFullName() != null) {
                user.setFullName(profileDTO.getFullName());
            }
            if (profileDTO.getPhoneNumber() != null) {
                user.setPhoneNumber(profileDTO.getPhoneNumber());
            }
            if (profileDTO.getBio() != null) {
                user.setBio(profileDTO.getBio());
            }
            if (profileDTO.getTimezone() != null) {
                user.setTimezone(profileDTO.getTimezone());
            }
            if (profileDTO.getLanguage() != null) {
                user.setLanguage(profileDTO.getLanguage());
            }
            if (profileDTO.getTheme() != null) {
                user.setTheme(profileDTO.getTheme());
            }
            
            // Update notification settings
            user.setNotificationEnabled(profileDTO.isNotificationEnabled());
            user.setEmailNotificationEnabled(profileDTO.isEmailNotificationEnabled());
            user.setSoundNotificationEnabled(profileDTO.isSoundNotificationEnabled());
            if (profileDTO.getNotificationAdvanceMinutes() != null) {
                user.setNotificationAdvanceMinutes(profileDTO.getNotificationAdvanceMinutes());
            }
            
            user.setUpdatedAt(LocalDateTime.now());
            User savedUser = userRepository.save(user);
            return new UserProfileDTO(savedUser);
        }
        throw new RuntimeException("User not found");
    }
    
    // Update avatar
    public String updateAvatar(Long userId, MultipartFile file) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            
            try {
                // Create upload directory if it doesn't exist
                Path uploadPath = Paths.get(UPLOAD_DIR);
                if (!Files.exists(uploadPath)) {
                    Files.createDirectories(uploadPath);
                }
                
                // Generate unique filename
                String originalFilename = file.getOriginalFilename();
                String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
                String filename = UUID.randomUUID().toString() + fileExtension;
                
                // Save file
                Path filePath = uploadPath.resolve(filename);
                Files.copy(file.getInputStream(), filePath);
                
                // Update user avatar URL
                String avatarUrl = "/avatars/" + filename;
                user.setAvatarUrl(avatarUrl);
                user.setUpdatedAt(LocalDateTime.now());
                userRepository.save(user);
                
                return avatarUrl;
                
            } catch (IOException e) {
                throw new RuntimeException("Failed to upload avatar", e);
            }
        }
        throw new RuntimeException("User not found");
    }
    
    // Change password
    public void changePassword(Long userId, String currentPassword, String newPassword) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            
            // Verify current password
            if (!passwordEncoder.matches(currentPassword, user.getPassword())) {
                throw new RuntimeException("Current password is incorrect");
            }
            
            // Update password
            user.setPassword(passwordEncoder.encode(newPassword));
            user.setUpdatedAt(LocalDateTime.now());
            userRepository.save(user);
        } else {
            throw new RuntimeException("User not found");
        }
    }
    
    // Update email
    public void updateEmail(Long userId, String newEmail) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            
            // Check if email is already taken
            Optional<User> existingUser = userRepository.findByEmail(newEmail);
            if (existingUser.isPresent() && !existingUser.get().getId().equals(userId)) {
                throw new RuntimeException("Email is already taken");
            }
            
            user.setEmail(newEmail);
            user.setUpdatedAt(LocalDateTime.now());
            userRepository.save(user);
        } else {
            throw new RuntimeException("User not found");
        }
    }
    
    // Update username
    public void updateUsername(Long userId, String newUsername) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            
            // Check if username is already taken
            Optional<User> existingUser = userRepository.findByUsername(newUsername);
            if (existingUser.isPresent() && !existingUser.get().getId().equals(userId)) {
                throw new RuntimeException("Username is already taken");
            }
            
            user.setUsername(newUsername);
            user.setUpdatedAt(LocalDateTime.now());
            userRepository.save(user);
        } else {
            throw new RuntimeException("User not found");
        }
    }
    
    // Delete account
    public void deleteAccount(Long userId, String password) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            
            // Verify password
            if (!passwordEncoder.matches(password, user.getPassword())) {
                throw new RuntimeException("Password is incorrect");
            }
            
            // Soft delete - mark as inactive
            user.setActive(false);
            user.setUpdatedAt(LocalDateTime.now());
            userRepository.save(user);
        } else {
            throw new RuntimeException("User not found");
        }
    }
    
    // Get user by ID
    public Optional<User> getUserById(Long userId) {
        return userRepository.findById(userId);
    }
    
    // Update last login
    public void updateLastLogin(Long userId) {
        Optional<User> userOpt = userRepository.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            user.setLastLogin(LocalDateTime.now());
            userRepository.save(user);
        }
    }
}
