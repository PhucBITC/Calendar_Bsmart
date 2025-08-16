package com.bsmart.repository;

import com.bsmart.domain.Task;
import com.bsmart.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {
    // Tìm tasks theo user
    List<Task> findByUser(User user);
    
    // Đếm số lượng tasks của user
    long countByUser(User user);
}
