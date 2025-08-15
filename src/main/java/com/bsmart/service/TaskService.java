package com.bsmart.service;

import com.bsmart.domain.Task;
import com.bsmart.domain.User;
import com.bsmart.repository.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TaskService {

    @Autowired
    private TaskRepository taskRepository;

    // Lấy tất cả nhiệm vụ
    public List<Task> getAllTasks() {
        return taskRepository.findAll();
    }

    // Lấy tasks theo user
    public List<Task> getTasksByUser(User user) {
        return taskRepository.findByUser(user);
    }

    // Lưu nhiệm vụ
    public Task saveTask(Task task) {
        return taskRepository.save(task);
    }

    public void deleteTaskById(Long id) {
        taskRepository.deleteById(id);
    }

    public Task getTaskById(Long id) {
        Optional<Task> optional = taskRepository.findById(id);
        return optional.orElse(null);
    }
}
