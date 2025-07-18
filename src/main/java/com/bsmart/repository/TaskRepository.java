package com.bsmart.repository;

import com.bsmart.domain.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {
    // Tự động có sẵn các hàm như:
    // - findAll()
    // - findById()
    // - save()
    // - deleteById()
}
