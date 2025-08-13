package com.bsmart.controller.client;

import com.bsmart.domain.FixedSchedule;
import com.bsmart.domain.GeneratedScheduleDTO;
import com.bsmart.service.FixedScheduleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/schedule")
public class FixedScheduleController {

    @Autowired
    private FixedScheduleService fixedScheduleService;

    // Hiển thị form thêm mới hoặc cập nhật
    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("schedule", new FixedSchedule());
        return "client/schedule/lichmoi";
    }

    // Lưu hoặc cập nhật lịch
    @PostMapping("/save")
    public String save(@ModelAttribute FixedSchedule schedule) {
        System.out.println(schedule.getStartTime()); // check giá trị
        System.out.println(schedule.getEndTime());
        fixedScheduleService.saveSchedule(schedule);
        return "redirect:/schedule/list";
    }

    // Danh sách tất cả lịch cố định
    @GetMapping("/list")
    public String showList(Model model) {
        model.addAttribute("schedules", fixedScheduleService.getAllSchedules());
        return "client/schedule/list";
    }

    // Xóa lịch
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Long id) {
        fixedScheduleService.deleteSchedule(id);
        return "redirect:/schedule/list";
    }

    // Sửa lịch (load dữ liệu lên form)
    @GetMapping("/edit/{id}")
    public String edit(@PathVariable Long id, Model model) {
        model.addAttribute("schedule", fixedScheduleService.getScheduleById(id));
        return "client/schedule/add"; // tái sử dụng form add
    }

    // Tự động lập lịch sớm nhất và tư động lập lịch thời gian rảnh
    @PostMapping("/auto-generate")
    public String autoGenerateSchedule(@RequestParam(name = "mode", defaultValue = "early") String mode, Model model) {
        List<GeneratedScheduleDTO> suggestedSchedule;

        if (mode.equals("balanced")) {
            suggestedSchedule = fixedScheduleService.generateBalancedSchedule();
        } else {
            suggestedSchedule = fixedScheduleService.generateOptimalSchedule(); // mặc định
        }

        model.addAttribute("suggestedSchedule", suggestedSchedule);
        return "client/schedule/suggested";
    }

}
