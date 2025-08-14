<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - BSmart Calendar</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .profile-container {
            padding: 40px 20px;
        }
        
        .profile-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
            position: relative;
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 3rem;
            border: 4px solid rgba(255,255,255,0.3);
        }
        
        .profile-header h2 {
            margin: 0 0 10px;
            font-weight: 600;
        }
        
        .profile-header p {
            margin: 0;
            opacity: 0.9;
        }
        
        .profile-body {
            padding: 40px 30px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            display: block;
        }
        
        .form-control {
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            padding: 12px 16px;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .form-control:disabled {
            background-color: #f8f9fa;
            color: #6c757d;
        }
        
        .btn-update {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 12px 30px;
            font-weight: 600;
            font-size: 16px;
            color: white;
            transition: transform 0.2s ease;
        }
        
        .btn-update:hover {
            transform: translateY(-2px);
            color: white;
        }
        
        .btn-back {
            background: #6c757d;
            border: none;
            border-radius: 10px;
            padding: 12px 30px;
            font-weight: 600;
            font-size: 16px;
            color: white;
            transition: all 0.2s ease;
        }
        
        .btn-back:hover {
            background: #5a6268;
            color: white;
        }
        
        .alert {
            border-radius: 10px;
            margin-bottom: 25px;
        }
        
        .info-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
        }
        
        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #dee2e6;
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
        }
        
        .info-value {
            color: #6c757d;
        }
        
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            margin-bottom: 25px;
        }
        
        .stats-number {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .stats-label {
            opacity: 0.9;
            font-size: 0.9rem;
        }
        
        .nav-tabs {
            border-bottom: 2px solid #e1e5e9;
            margin-bottom: 30px;
        }
        
        .nav-tabs .nav-link {
            border: none;
            color: #6c757d;
            font-weight: 600;
            padding: 15px 20px;
            position: relative;
        }
        
        .nav-tabs .nav-link.active {
            background: none;
            color: #667eea;
            border-bottom: 3px solid #667eea;
        }
        
        .tab-content {
            min-height: 300px;
        }
    </style>
</head>
<body>
    <div class="profile-container">
        <div class="profile-card">
            <div class="profile-header">
                <div class="profile-avatar">
                    <i class="fas fa-user"></i>
                </div>
                <h2>${user.fullName != null ? user.fullName : user.username}</h2>
                <p><i class="fas fa-envelope me-2"></i>${user.email}</p>
                <p><i class="fas fa-calendar me-2"></i>Thành viên từ 
                    <c:if test="${user.createdAt != null}">
                        ${user.createdAt.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"))}
                    </c:if>
                </p>
            </div>
            
            <div class="profile-body">
                <!-- Thông báo -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        ${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <!-- Tabs -->
                <ul class="nav nav-tabs" id="profileTabs" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active" id="info-tab" data-bs-toggle="tab" data-bs-target="#info" type="button" role="tab">
                            <i class="fas fa-info-circle me-2"></i>Thông tin
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="edit-tab" data-bs-toggle="tab" data-bs-target="#edit" type="button" role="tab">
                            <i class="fas fa-edit me-2"></i>Chỉnh sửa
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link" id="stats-tab" data-bs-toggle="tab" data-bs-target="#stats" type="button" role="tab">
                            <i class="fas fa-chart-bar me-2"></i>Thống kê
                        </button>
                    </li>
                </ul>
                
                <div class="tab-content" id="profileTabsContent">
                    <!-- Tab thông tin -->
                    <div class="tab-pane fade show active" id="info" role="tabpanel">
                        <div class="info-card">
                            <div class="info-item">
                                <span class="info-label">
                                    <i class="fas fa-user me-2"></i>Tên đăng nhập
                                </span>
                                <span class="info-value">${user.username}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">
                                    <i class="fas fa-envelope me-2"></i>Email
                                </span>
                                <span class="info-value">${user.email}</span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">
                                    <i class="fas fa-id-card me-2"></i>Họ và tên
                                </span>
                                <span class="info-value">
                                    ${user.fullName != null ? user.fullName : 'Chưa cập nhật'}
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">
                                    <i class="fas fa-phone me-2"></i>Số điện thoại
                                </span>
                                <span class="info-value">
                                    ${user.phoneNumber != null ? user.phoneNumber : 'Chưa cập nhật'}
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">
                                    <i class="fas fa-user-tag me-2"></i>Vai trò
                                </span>
                                <span class="info-value">
                                    <span class="badge bg-primary">${user.role}</span>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="info-label">
                                    <i class="fas fa-calendar-plus me-2"></i>Ngày tạo tài khoản
                                </span>
                                <span class="info-value">
                                    <c:if test="${user.createdAt != null}">
                                        ${user.createdAt.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))}
                                    </c:if>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Tab chỉnh sửa -->
                    <div class="tab-pane fade" id="edit" role="tabpanel">
                        <form:form method="post" action="/auth/profile" modelAttribute="user">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label" for="username">
                                            <i class="fas fa-user me-2"></i>Tên đăng nhập
                                        </label>
                                        <form:input 
                                            path="username" 
                                            class="form-control" 
                                            id="username"
                                            disabled="true"/>
                                        <small class="text-muted">Không thể thay đổi tên đăng nhập</small>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label class="form-label" for="email">
                                            <i class="fas fa-envelope me-2"></i>Email
                                        </label>
                                        <form:input 
                                            path="email" 
                                            type="email"
                                            class="form-control" 
                                            id="email"
                                            disabled="true"/>
                                        <small class="text-muted">Không thể thay đổi email</small>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label" for="fullName">
                                    <i class="fas fa-id-card me-2"></i>Họ và tên
                                </label>
                                <form:input 
                                    path="fullName" 
                                    class="form-control" 
                                    id="fullName"
                                    placeholder="Nhập họ và tên của bạn"/>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label" for="phoneNumber">
                                    <i class="fas fa-phone me-2"></i>Số điện thoại
                                </label>
                                <form:input 
                                    path="phoneNumber" 
                                    class="form-control" 
                                    id="phoneNumber"
                                    placeholder="Nhập số điện thoại"/>
                            </div>
                            
                            <div class="d-flex gap-3">
                                <button type="submit" class="btn btn-update">
                                    <i class="fas fa-save me-2"></i>Cập nhật thông tin
                                </button>
                            </div>
                        </form:form>
                    </div>
                    
                    <!-- Tab thống kê -->
                    <div class="tab-pane fade" id="stats" role="tabpanel">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="stats-card">
                                    <div class="stats-number">${user.tasks != null ? user.tasks.size() : 0}</div>
                                    <div class="stats-label">Công việc đã tạo</div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="stats-card">
                                    <div class="stats-number">${user.fixedSchedules != null ? user.fixedSchedules.size() : 0}</div>
                                    <div class="stats-label">Lịch cố định</div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="stats-card">
                                    <div class="stats-number">
                                        <c:if test="${user.createdAt != null}">
                                            ${java.time.temporal.ChronoUnit.DAYS.between(user.createdAt.toLocalDate(), java.time.LocalDate.now())}
                                        </c:if>
                                    </div>
                                    <div class="stats-label">Ngày sử dụng</div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="info-card mt-4">
                            <h5 class="mb-3"><i class="fas fa-chart-line me-2"></i>Hoạt động gần đây</h5>
                            <p class="text-muted">Chức năng thống kê chi tiết sẽ được cập nhật trong phiên bản tiếp theo.</p>
                        </div>
                    </div>
                </div>
                
                <!-- Buttons -->
                <div class="d-flex justify-content-between mt-4">
                    <a href="/client/task/list" class="btn btn-back">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </a>
                    <a href="/auth/logout" class="btn btn-outline-danger">
                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto dismiss alerts after 5 seconds
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
        
        // Tab switching
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const activeTab = urlParams.get('tab');
            
            if (activeTab) {
                const tabButton = document.getElementById(activeTab + '-tab');
                const tabContent = document.getElementById(activeTab);
                
                if (tabButton && tabContent) {
                    // Remove active class from all tabs
                    document.querySelectorAll('.nav-link').forEach(link => link.classList.remove('active'));
                    document.querySelectorAll('.tab-pane').forEach(pane => {
                        pane.classList.remove('show', 'active');
                    });
                    
                    // Add active class to selected tab
                    tabButton.classList.add('active');
                    tabContent.classList.add('show', 'active');
                }
            }
        });
    </script>
</body>
</html>