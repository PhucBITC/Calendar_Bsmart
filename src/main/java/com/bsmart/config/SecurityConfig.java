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
                handler.setDefaultTargetUrl("/client/task/list");
                handler.setUseReferer(false);
                return handler;
        }

        @Bean
        public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
                http
                                .authorizeHttpRequests(authz -> authz
                                                .anyRequest().permitAll() // tất cả URL đều được phép
                                )
                                .formLogin(form -> form
                                                .loginPage("/auth/login") // hiển thị form login
                                                .permitAll())
                                .csrf(csrf -> csrf.disable()); // tạm thời tắt CSRF để test
                return http.build();
        }

}
