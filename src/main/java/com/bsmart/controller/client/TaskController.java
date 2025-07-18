package com.bsmart.controller.client;

import com.bsmart.domain.Task;
import com.bsmart.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/tasks")
public class TaskController {

    @Autowired
    private TaskService taskService;

    // Hiển thị form thêm nhiệm vụ
    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("task", new Task());
        return "client/task/add";
    }

    // Xử lý form lưu task
    @PostMapping("/save")
    public String saveTask(@ModelAttribute("task") Task task) {
        taskService.saveTask(task);
        return "redirect:/tasks/list";
    }

    // Hiển thị danh sách nhiệm vụ
    @GetMapping("/list")
    public String showTaskList(Model model) {
        model.addAttribute("tasks", taskService.getAllTasks());
        return "client/task/list";
    }

    // Xoá nhiệm vụ theo id
    @GetMapping("/delete/{id}")
    public String deleteTask(@PathVariable("id") Long id) {
        taskService.deleteTaskById(id);
        return "redirect:/tasks/list";
    }

    // Hiển thị form sửa task theo id
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Long id, Model model) {
        Task task = taskService.getTaskById(id);
        model.addAttribute("task", task);
        return "client/task/edit"; // Giao diện sửa riêng
    }

}
