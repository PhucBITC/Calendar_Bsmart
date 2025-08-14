package com.bsmart.service;

import com.bsmart.domain.User;
import com.bsmart.domain.UserRegistrationDTO;
import com.bsmart.domain.UserRole;
import com.bsmart.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.Optional;

@Service
@Transactional
public class UserService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public User registerUser(UserRegistrationDTO registrationDTO) {
        if (!registrationDTO.isPasswordMatching()) {
            throw new RuntimeException("Mật khẩu xác nhận không khớp");
        }
        if (userRepository.existsByUsername(registrationDTO.getUsername())) {
            throw new RuntimeException("Tên người dùng đã tồn tại");
        }
        if (userRepository.existsByEmail(registrationDTO.getEmail())) {
            throw new RuntimeException("Email đã được sử dụng");
        }

        User user = new User();
        user.setUsername(registrationDTO.getUsername());
        user.setEmail(registrationDTO.getEmail());
        user.setPassword(passwordEncoder.encode(registrationDTO.getPassword()));
        user.setFullName(registrationDTO.getFullName());
        user.setPhoneNumber(registrationDTO.getPhoneNumber());
        user.setRole(UserRole.USER);
        user.setActive(true);

        return userRepository.save(user);
    }

    public Optional<User> findByUsernameOrEmail(String usernameOrEmail) {
        return userRepository.findByUsernameOrEmail(usernameOrEmail);
    }

    public User getCurrentUser(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Không tìm thấy người dùng hiện tại"));
    }

    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    public User updateUser(User user) {
        return userRepository.save(user);
    }

    public boolean checkPassword(User user, String rawPassword) {
        return passwordEncoder.matches(rawPassword, user.getPassword());
    }

    /*** === Phần bắt buộc cho Spring Security === */
    @Override
    public UserDetails loadUserByUsername(String usernameOrEmail) throws UsernameNotFoundException {
        User user = userRepository.findByUsernameOrEmail(usernameOrEmail)
                .orElseThrow(() -> new UsernameNotFoundException("Không tìm thấy người dùng: " + usernameOrEmail));

        if (!user.isActive()) {
            throw new UsernameNotFoundException("Tài khoản đã bị vô hiệu hóa: " + usernameOrEmail);
        }

        return new org.springframework.security.core.userdetails.User(
                user.getUsername(),
                user.getPassword(),
                Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + user.getRole().getValue())));
    }
}