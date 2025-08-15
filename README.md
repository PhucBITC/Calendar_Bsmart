# B-Smart Calendar - Hệ Thống Quản Lý Lịch Trình Thông Minh

## 🚀 Tổng Quan

B-Smart Calendar là một ứng dụng quản lý lịch trình thông minh được xây dựng bằng Spring Boot, cung cấp các tính năng quản lý lịch trình, tác vụ, thông báo và quản trị hệ thống toàn diện.

## ✨ Tính Năng Chính

### 📅 Quản Lý Lịch Trình
- **Lịch cố định**: Tạo và quản lý các lịch trình cố định theo ngày/tuần/tháng
- **Lịch tự động**: Hệ thống sinh lịch tự động dựa trên tác vụ và thời gian rảnh
- **Lặp lại**: Hỗ trợ các pattern lặp lại (hàng ngày, hàng tuần, hàng tháng)
- **Xóa thông minh**: Tùy chọn xóa một sự kiện hoặc toàn bộ chuỗi lặp lại

### 👤 Quản Lý Hồ Sơ Người Dùng
- **Thông tin cá nhân**: Cập nhật thông tin cá nhân, avatar, bio
- **Cài đặt giao diện**: Chọn theme sáng/tối/tự động
- **Ngôn ngữ và múi giờ**: Hỗ trợ đa ngôn ngữ và múi giờ
- **Bảo mật**: Đổi mật khẩu, email, username

### 🔔 Hệ Thống Thông Báo
- **Thông báo trong ứng dụng**: Hiển thị thông báo real-time
- **Thông báo email**: Gửi email khi có lịch trình sắp tới
- **Âm thanh**: Hỗ trợ thông báo có âm thanh
- **Tùy chỉnh thời gian**: Cài đặt thời gian thông báo trước (5-10 phút)

### 🎨 Giao Diện Người Dùng
- **Theme sáng/tối**: Chuyển đổi theme theo sở thích
- **Responsive**: Tương thích với mọi thiết bị
- **Giao diện hiện đại**: Thiết kế Material Design
- **Tương tác mượt mà**: Animations và transitions

### 🔧 Quản Trị Hệ Thống (Admin)
- **Quản lý người dùng**: Xem, chỉnh sửa, kích hoạt/vô hiệu hóa người dùng
- **Thống kê hệ thống**: Dashboard với các chỉ số quan trọng
- **Gửi thông báo**: Gửi thông báo hệ thống cho người dùng
- **Bảo trì**: Dọn dẹp dữ liệu cũ, kiểm tra sức khỏe hệ thống

## 🛠 Công Nghệ Sử Dụng

### Backend
- **Spring Boot 3.4.4**: Framework chính
- **Spring Security**: Bảo mật và xác thực
- **Spring Data JPA**: Truy cập dữ liệu
- **Spring Mail**: Gửi email
- **MySQL**: Cơ sở dữ liệu
- **Maven**: Quản lý dependencies

### Frontend
- **JSP**: Template engine
- **HTML5/CSS3**: Giao diện người dùng
- **JavaScript (ES6+)**: Tương tác client-side
- **Bootstrap**: Framework CSS

## 📦 Cài Đặt và Chạy

### Yêu Cầu Hệ Thống
- Java 21+
- MySQL 8.0+
- Maven 3.6+

### Bước 1: Clone Repository
```bash
git clone <repository-url>
cd B_smart
```

### Bước 2: Cấu Hình Database
1. Tạo database MySQL:
```sql
CREATE DATABASE b_smart CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. Cập nhật thông tin database trong `application.properties`:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/b_smart
spring.datasource.username=your_username
spring.datasource.password=your_password
```

### Bước 3: Cấu Hình Email (Tùy Chọn)
Để sử dụng tính năng gửi email, cập nhật cấu hình email trong `application.properties`:
```properties
spring.mail.username=your-email@gmail.com
spring.mail.password=your-app-password
```

### Bước 4: Chạy Ứng Dụng
```bash
mvn spring-boot:run
```

Ứng dụng sẽ chạy tại: `http://localhost:8082`

## 📋 Cấu Trúc Dự Án

```
src/
├── main/
│   ├── java/com/bsmart/
│   │   ├── domain/           # Entity classes
│   │   ├── repository/       # Data access layer
│   │   ├── service/          # Business logic
│   │   ├── controller/       # Web controllers
│   │   └── config/           # Configuration classes
│   ├── resources/
│   │   └── application.properties
│   └── webapp/
│       └── WEB-INF/view/     # JSP templates
└── test/                     # Test files
```

## 🔐 Bảo Mật

### Xác Thực và Phân Quyền
- **Đăng ký/Đăng nhập**: Hệ thống xác thực an toàn
- **Phân quyền**: USER và ADMIN roles
- **Session Management**: Quản lý phiên làm việc
- **Password Encryption**: Mã hóa mật khẩu với BCrypt

### Bảo Vệ Dữ Liệu
- **Input Validation**: Kiểm tra đầu vào
- **SQL Injection Protection**: Sử dụng JPA/Hibernate
- **XSS Protection**: Làm sạch dữ liệu đầu ra
- **CSRF Protection**: Bảo vệ chống tấn công CSRF

## 📊 API Endpoints

### Authentication
- `POST /auth/register` - Đăng ký
- `POST /auth/login` - Đăng nhập
- `POST /auth/logout` - Đăng xuất

### Profile Management
- `GET /profile` - Xem hồ sơ
- `POST /profile/update` - Cập nhật hồ sơ
- `POST /profile/avatar` - Upload avatar
- `POST /profile/change-password` - Đổi mật khẩu

### Notifications
- `GET /notifications` - Danh sách thông báo
- `GET /notifications/api/unread-count` - Số thông báo chưa đọc
- `POST /notifications/api/{id}/read` - Đánh dấu đã đọc

### Admin (Chỉ ADMIN)
- `GET /admin` - Dashboard admin
- `GET /admin/users` - Quản lý người dùng
- `POST /admin/notifications/send` - Gửi thông báo hệ thống

## 🎯 Tính Năng Nổi Bật

### 1. Sinh Lịch Tự Động
- Phân tích tác vụ và thời gian rảnh
- Tự động sắp xếp lịch trình tối ưu
- Hỗ trợ ưu tiên và deadline

### 2. Thông Báo Thông Minh
- Thông báo trước 5-10 phút (tùy chỉnh)
- Email notification
- Âm thanh thông báo
- Real-time updates

### 3. Giao Diện Hiện Đại
- Theme sáng/tối
- Responsive design
- Animations mượt mà
- UX/UI tối ưu

### 4. Quản Trị Toàn Diện
- Dashboard thống kê
- Quản lý người dùng
- Monitoring hệ thống
- Bảo trì tự động

## 🚀 Tính Năng Mới (Phiên Bản Hiện Tại)

### ✅ Đã Hoàn Thành
- [x] Hệ thống thông báo hoàn chỉnh
- [x] Quản lý hồ sơ người dùng
- [x] Theme sáng/tối
- [x] Admin dashboard
- [x] Email notifications
- [x] Xóa lịch thông minh (một sự kiện/toàn bộ chuỗi)
- [x] Upload avatar
- [x] Cài đặt thông báo tùy chỉnh

### 🔄 Đang Phát Triển
- [ ] Mobile app
- [ ] Calendar sync (Google, Outlook)
- [ ] Team collaboration
- [ ] Advanced analytics

## 🤝 Đóng Góp

1. Fork dự án
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Tạo Pull Request

## 📝 License

Dự án này được phân phối dưới MIT License. Xem file `LICENSE` để biết thêm chi tiết.

## 📞 Liên Hệ

- **Email**: support@bsmart.com
- **Website**: https://bsmart.com
- **Documentation**: https://docs.bsmart.com

---

**B-Smart Calendar** - Quản lý thời gian thông minh, hiệu quả hơn! 🎯
