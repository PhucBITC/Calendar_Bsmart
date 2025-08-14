package com.bsmart.service;

import com.bsmart.domain.FixedSchedule;
import com.bsmart.repository.FixedScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class ReminderService {

	@Autowired
	private FixedScheduleRepository fixedScheduleRepository;

	@Autowired(required = false)
	private JavaMailSender mailSender; // optional if configured

	// Chạy mỗi phút để kiểm tra nhắc lịch sắp diễn ra trong 5 phút tới
	@Scheduled(cron = "0 * * * * *")
	public void checkUpcomingEvents() {
		LocalDate today = LocalDate.now();
		LocalTime now = LocalTime.now();
		LocalTime threshold = now.plusMinutes(5);

		List<FixedSchedule> all = fixedScheduleRepository.findAll();
		for (FixedSchedule fs : all) {
			try {
				if (fs.getDayOfWeek() == null || fs.getStartTime() == null) continue;
				LocalDate date = LocalDate.parse(fs.getDayOfWeek());
				if (!date.equals(today)) continue;
				LocalTime start = fs.getStartTime();
				if (!start.isBefore(threshold)) continue; // chỉ khi start <= now+5m
				if (start.isBefore(now)) continue; // bỏ sự kiện đã qua

				// Gửi email nếu cấu hình mail
				if (mailSender != null && fs.getUser() != null && fs.getUser().getEmail() != null) {
					SimpleMailMessage msg = new SimpleMailMessage();
					msg.setTo(fs.getUser().getEmail());
					msg.setSubject("Nhắc lịch: " + fs.getDescription());
					msg.setText("Sự kiện '" + fs.getDescription() + "' sẽ bắt đầu lúc " + start.format(DateTimeFormatter.ofPattern("HH:mm")) + ".");
					try { mailSender.send(msg); } catch (Exception ignore) {}
				}
			} catch (Exception ignore) {}
		}
	}
}


