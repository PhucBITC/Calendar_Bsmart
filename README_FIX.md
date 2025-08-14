# Sửa lỗi phân quyền người dùng - BSmart Calendar

## Vấn đề ban đầu
Dự án có vấn đề là tất cả người dùng đều thấy chung một danh sách schedule, không phân biệt được dữ liệu của từng user. Ví dụ: tài khoản A tạo lịch thì tài khoản B cũng thấy được.

## Nguyên nhân
1. **Controller không lọc dữ liệu theo user**: FixedScheduleController trả về tất cả dữ liệu từ database
2. **Service không có phương thức lọc theo user**: Chỉ có `getAllSchedules()`
3. **Repository thiếu phương thức findByUser**: Không có cách lấy dữ liệu theo user
4. **Không gán user khi lưu**: Khi tạo schedule mới không gán user hiện tại
5. **Security chưa được cấu hình đúng**: Không yêu cầu đăng nhập cho các endpoint quan trọng

## Các thay đổi đã thực hiện

### 1. Cập nhật Repository
**File: `FixedScheduleRepository.java`**
- Thêm phương thức `List<FixedSchedule> findByUser(User user)`

### 2. Cập nhật Service
**File: `FixedScheduleService.java`**
- Thêm `getSchedulesByUser(User user)`
- Thêm `getSchedulesByUsername(String username)`
- Thêm `saveSchedule(FixedSchedule schedule, String username)` - gán user khi lưu
- Thêm `isScheduleOwnedByUser(Long scheduleId, String username)` - kiểm tra quyền sở hữu

### 3. Cập nhật Controller
**File: `FixedScheduleController.java`**
- Thêm `Principal principal` parameter vào tất cả methods
- `showList()`: Lọc theo user hiện tại
- `save()` và `saveApi()`: Gán user khi lưu
- `delete()` và `deleteApi()`: Kiểm tra quyền sở hữu
- `edit()`: Kiểm tra quyền sở hữu
- `getSchedulesApi()`: Lọc theo user hiện tại
- `getScheduleApi()`: Kiểm tra quyền truy cập

### 4. Cập nhật Security
**File: `SecurityConfig.java`**
- Yêu cầu đăng nhập cho `/schedule/**`
- Cấu hình form login với Spring Security
- Redirect sau đăng nhập thành công về `/schedule/add`

### 5. Cập nhật AuthController
**File: `AuthController.java`**
- Thêm method `home()` để redirect từ trang chủ
- Loại bỏ custom login POST method
- Sử dụng Spring Security form login
- Redirect sau đăng ký thành công về `/schedule/add`

### 6. Cập nhật View
**File: `login.jsp`**
- Chuyển từ Spring form sang HTML form thông thường
- Sử dụng `name="username"` và `name="password"` cho Spring Security

## Kết quả
Sau khi áp dụng các thay đổi:

1. **Phân quyền dữ liệu**: Mỗi user chỉ thấy schedule của mình
2. **Bảo mật**: Chỉ user sở hữu mới có thể sửa/xóa dữ liệu của mình
3. **Authentication**: Yêu cầu đăng nhập để truy cập các chức năng quan trọng
4. **Session management**: Sử dụng Spring Security để quản lý session
5. **Redirect đúng**: Sau đăng nhập/đăng ký sẽ vào trang tạo lịch mới

## Cách test
1. Tạo 2 tài khoản khác nhau (A và B)
2. Đăng nhập tài khoản A, tạo một số schedule
3. Đăng xuất và đăng nhập tài khoản B
4. Kiểm tra xem tài khoản B có thấy dữ liệu của A không (không nên thấy)
5. Tạo dữ liệu mới với tài khoản B
6. Đăng nhập lại tài khoản A, kiểm tra xem có thấy dữ liệu của B không (không nên thấy)

## Lưu ý
- Cần restart ứng dụng sau khi thay đổi
- Dữ liệu cũ trong database có thể không có user_id, cần xóa hoặc cập nhật
- Đảm bảo database có foreign key constraint giữa schedule và user
- Task vẫn hoạt động như cũ, không bị ảnh hưởng
