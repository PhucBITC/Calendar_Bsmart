package com.bsmart.repository;

import com.bsmart.domain.FixedSchedule;
import com.bsmart.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FixedScheduleRepository extends JpaRepository<FixedSchedule, Long> {
    // Tìm schedules theo user
    List<FixedSchedule> findByUser(User user);
    
    // Bạn có thể thêm custom query sau nếu cần, ví dụ tìm theo thứ trong tuần, v.v.
}
