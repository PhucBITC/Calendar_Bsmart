package com.bsmart.config;

import com.bsmart.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

        @Autowired
        private UserService userService;

        @Autowired
        private PasswordEncoder passwordEncoder; // từ AppConfig

        @Bean
        public AuthenticationManager authenticationManager(HttpSecurity http) throws Exception {
                AuthenticationManagerBuilder authBuilder = http.getSharedObject(AuthenticationManagerBuilder.class);

                authBuilder
                                .userDetailsService(userService)
                                .passwordEncoder(passwordEncoder);

                return authBuilder.build();
        }

        @Bean
        public AuthenticationSuccessHandler authenticationSuccessHandler() {
                SimpleUrlAuthenticationSuccessHandler handler = new SimpleUrlAuthenticationSuccessHandler();
                handler.setDefaultTargetUrl("/schedule/add");
                handler.setUseReferer(false);
                return handler;
        }

        @Bean
        public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
                http
                                // Cho phép tất cả request tới các file static và trang auth
                                .authorizeHttpRequests(authz -> authz
                                                .requestMatchers(
                                                                "/auth/**",
                                                                "/client/css/**",
                                                                "/client/js/**",
                                                                "/client/image/**",
                                                                "/resources/**",
                                                                "/",
                                                                "/hello")
                                                .permitAll()
                                                // Yêu cầu đăng nhập cho các endpoint quan trọng
                                                .requestMatchers("/admin/**").hasRole("ADMIN")
                                                .requestMatchers("/schedule/**").authenticated()
                                                .anyRequest().permitAll()
                                )
                                .csrf(csrf -> csrf.disable()) // tạm thời tắt CSRF để form login custom hoạt động
                                .formLogin(form -> form
                                                .loginPage("/auth/login")
                                                .loginProcessingUrl("/auth/login")
                                                .successHandler(authenticationSuccessHandler())
                                                .failureUrl("/auth/login?error=true")
                                                .permitAll()
                                )
                                .logout(logout -> logout
                                                .logoutUrl("/auth/logout")
                                                .logoutSuccessUrl("/auth/login?logout=true")
                                                .permitAll()
                                );

                return http.build();
        }
}
