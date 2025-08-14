# BSmart Calendar - Lịch thông minh

Ứng dụng lịch thông minh với các tính năng quản lý lịch, sinh lịch tự động, thông báo và quản trị hệ thống.

## 🚀 Tính năng chính

### 📅 Quản lý lịch
- Tạo, chỉnh sửa, xóa lịch cố định
- Giao diện calendar đẹp mắt với theme sáng/tối
- Tìm kiếm lịch real-time
- Responsive design cho mobile

### 🧠 Sinh lịch thông minh
- Thuật toán EDF (Earliest Deadline First) + Greedy
- Tự động sắp xếp task theo deadline và priority
- Tôn trọng slot rảnh từ lịch cố định
- Gợi ý lịch tối ưu

### 🔔 Hệ thống thông báo
- **Web notifications**: Toaster + Browser Notification API
- **Email notifications**: Gửi email nhắc lịch (cần cấu hình)
- **Sound notifications**: Âm thanh nhắc nhở
- Cài đặt tùy chỉnh thông báo

### 👥 Quản lý người dùng
- Đăng ký, đăng nhập, đăng xuất
- Phân quyền USER/ADMIN
- Hồ sơ cá nhân
- Data isolation (mỗi user chỉ thấy dữ liệu của mình)

### 🛠️ Admin Dashboard
- Thống kê tổng quan hệ thống
- Quản lý người dùng (thăng/hạ quyền, xóa)
- Quản lý lịch (xem, sửa, xóa)
- Bộ lọc và tìm kiếm nâng cao

## 🛠️ Cài đặt

### Yêu cầu hệ thống
- Java 17+
- MySQL 8.0+
- Maven 3.6+

### Bước 1: Cấu hình database
1. Tạo database MySQL:
```sql
CREATE DATABASE b_smart CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. Cập nhật thông tin kết nối trong `src/main/resources/application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/b_smart?createDatabaseIfNotExist=true&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=123456
```

### Bước 2: Cấu hình email (tùy chọn)
Uncomment và cấu hình trong `application.properties`:
```properties
spring.mail.host=smtp.gmail.com
spring.mail.port=587
spring.mail.username=your-email@gmail.com
spring.mail.password=your-app-password
spring.mail.properties.mail.smtp.auth=true
spring.mail.properties.mail.smtp.starttls.enable=true
```

### Bước 3: Chạy ứng dụng
```bash
mvn spring-boot:run
```

Ứng dụng sẽ chạy tại: `http://localhost:8082`

## 📖 Hướng dẫn sử dụng

### Đăng ký tài khoản
1. Truy cập `http://localhost:8082/auth/register`
2. Điền thông tin đăng ký
3. Sau khi đăng ký thành công, sẽ được chuyển đến trang lịch

### Sử dụng lịch
1. **Tạo lịch mới**: Click nút "Tạo lịch mới" hoặc click vào ngày trong calendar
2. **Sinh lịch thông minh**: Click nút "Sinh lịch thông minh" để hệ thống tự động sắp xếp task
3. **Tìm kiếm**: Sử dụng ô tìm kiếm ở header
4. **Chuyển theme**: Click nút 🌙/☀️ để chuyển đổi giao diện sáng/tối

### Cài đặt thông báo
Trong sidebar, phần "Cài đặt thông báo":
- **Thông báo web**: Bật/tắt notification trên website
- **Thông báo email**: Bật/tắt email nhắc lịch
- **Âm thanh nhắc**: Bật/tắt âm thanh

### Admin Dashboard
1. **Tạo user ADMIN**: Trong database, set `role = 'ADMIN'` cho user mong muốn
2. **Truy cập**: Vào `/admin/dashboard` (cần đăng nhập với quyền ADMIN)
3. **Quản lý người dùng**: `/admin/users`
4. **Quản lý lịch**: `/admin/schedules`

## 🔧 Cấu trúc dự án

```
src/main/java/com/bsmart/
├── BsmartApplication.java          # Main application
├── config/                         # Cấu hình Spring
│   ├── AppConfig.java             # Cấu hình chung + email
│   ├── SecurityConfig.java        # Cấu hình bảo mật
│   └── WebMvcConfig.java          # Cấu hình MVC
├── controller/                     # Controllers
│   ├── admin/                     # Admin controllers
│   │   └── AdminController.java   # Quản lý admin
│   └── client/                    # Client controllers
│       ├── AuthController.java    # Xác thực
│       ├── FixedScheduleController.java # Quản lý lịch
│       └── TaskController.java    # Quản lý task
├── domain/                        # Entities & DTOs
│   ├── FixedSchedule.java         # Entity lịch cố định
│   ├── FixedScheduleDTO.java      # DTO cho API
│   ├── GeneratedScheduleDTO.java  # DTO lịch được sinh
│   ├── Task.java                  # Entity task
│   ├── User.java                  # Entity user
│   ├── UserLoginDTO.java          # DTO đăng nhập
│   ├── UserRegistrationDTO.java   # DTO đăng ký
│   └── UserRole.java              # Enum vai trò
├── repository/                    # Data access layer
│   ├── FixedScheduleRepository.java
│   ├── TaskRepository.java
│   └── UserRepository.java
└── service/                       # Business logic
    ├── FixedScheduleService.java  # Logic lịch + sinh lịch thông minh
    ├── ReminderService.java       # Gửi thông báo
    ├── TaskService.java           # Logic task
    └── UserService.java           # Logic user
```

## 🎨 Giao diện

### Theme System
- **Light mode**: Giao diện sáng, dễ nhìn
- **Dark mode**: Giao diện tối, bảo vệ mắt
- Tự động lưu preference vào localStorage

### Responsive Design
- Desktop: Layout đầy đủ với sidebar
- Mobile: Layout tối ưu, hamburger menu
- Tablet: Layout trung gian

### Components
- **Header**: Search, theme toggle, profile dropdown
- **Sidebar**: Mini calendar, settings, buttons
- **Main content**: Calendar view (month/week/day)
- **Dialogs**: Form tạo/sửa lịch, confirm delete

## 🔐 Bảo mật

### Spring Security
- Form-based authentication
- Role-based access control (USER/ADMIN)
- CSRF protection
- Session management

### Data Isolation
- Mỗi user chỉ thấy dữ liệu của mình
- API endpoints kiểm tra quyền truy cập
- Admin có thể xem tất cả dữ liệu

## 📊 Thuật toán sinh lịch thông minh

### EDF (Earliest Deadline First)
- Sắp xếp task theo deadline gần nhất
- Ưu tiên task có deadline sớm

### Greedy Algorithm
- Sắp xếp theo priority (cao → thấp)
- Tối ưu thời gian sử dụng

### Kết hợp
1. Lọc task theo deadline hợp lệ
2. Sắp xếp theo EDF + Greedy
3. Tìm slot rảnh từ fixed schedules
4. Gán task vào slot phù hợp

## 🔔 Hệ thống thông báo

### Web Notifications
- Toaster notifications
- Browser Notification API
- Tự động nhắc 5 phút trước giờ hẹn

### Email Notifications
- Spring Mail integration
- HTML email template
- Cron job chạy mỗi phút

### Sound Notifications
- WebAudio API
- Beep sound khi có nhắc lịch

## 🚀 Deployment

### Production
1. Cấu hình database production
2. Cấu hình email SMTP
3. Build JAR file: `mvn clean package`
4. Chạy: `java -jar target/bsmart-0.0.1-SNAPSHOT.jar`

### Docker (tùy chọn)
```dockerfile
FROM openjdk:17-jdk-slim
COPY target/bsmart-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8082
ENTRYPOINT ["java","-jar","/app.jar"]
```

## 🐛 Troubleshooting

### Lỗi kết nối database
- Kiểm tra MySQL service đang chạy
- Kiểm tra thông tin kết nối trong `application.properties`
- Đảm bảo database `b_smart` đã được tạo

### Lỗi email
- Kiểm tra cấu hình SMTP
- Đảm bảo email/password đúng
- Kiểm tra firewall/antivirus

### Lỗi permission
- Đảm bảo user có quyền ADMIN để truy cập admin panel
- Kiểm tra role trong database

## 📝 Changelog

### v1.0.0 (Current)
- ✅ Giao diện calendar hoàn chỉnh
- ✅ Sinh lịch thông minh (EDF + Greedy)
- ✅ Hệ thống thông báo (web + email + sound)
- ✅ Admin dashboard đầy đủ
- ✅ Theme system (light/dark)
- ✅ Responsive design
- ✅ Data isolation per user
- ✅ Search functionality
- ✅ User management

## 🤝 Contributing

1. Fork dự án
2. Tạo feature branch
3. Commit changes
4. Push to branch
5. Tạo Pull Request

## 📄 License

MIT License - xem file LICENSE để biết thêm chi tiết.

## 📞 Support

Nếu có vấn đề hoặc câu hỏi, vui lòng tạo issue trên GitHub repository.
