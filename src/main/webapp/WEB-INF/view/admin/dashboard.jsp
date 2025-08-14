<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - BSmart Calendar</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f8fafc;
            color: #334155;
        }

        .header {
            background: white;
            padding: 1rem 2rem;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .header h1 {
            color: #2563eb;
            font-size: 1.5rem;
        }

        .header-nav {
            display: flex;
            gap: 1rem;
        }

        .nav-link {
            text-decoration: none;
            color: #64748b;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            transition: all 0.2s;
        }

        .nav-link:hover {
            background: #f1f5f9;
            color: #2563eb;
        }

        .nav-link.active {
            background: #2563eb;
            color: white;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 0.75rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            border-left: 4px solid #2563eb;
        }

        .stat-card.users {
            border-left-color: #16a34a;
        }

        .stat-card.schedules {
            border-left-color: #ea580c;
        }

        .stat-card.tasks {
            border-left-color: #7c3aed;
        }

        .stat-card.admins {
            border-left-color: #dc2626;
        }

        .stat-title {
            font-size: 0.875rem;
            color: #64748b;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: bold;
            color: #1e293b;
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
        }

        .action-card {
            background: white;
            padding: 1.5rem;
            border-radius: 0.75rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .action-card h3 {
            margin-bottom: 1rem;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            margin-right: 0.5rem;
            margin-bottom: 0.5rem;
        }

        .btn-primary {
            background: #2563eb;
            color: white;
        }

        .btn-primary:hover {
            background: #1d4ed8;
        }

        .btn-secondary {
            background: #64748b;
            color: white;
        }

        .btn-secondary:hover {
            background: #475569;
        }

        .btn-danger {
            background: #dc2626;
            color: white;
        }

        .btn-danger:hover {
            background: #b91c1c;
        }

        .btn-success {
            background: #16a34a;
            color: white;
        }

        .btn-success:hover {
            background: #15803d;
        }

        .recent-activity {
            background: white;
            padding: 1.5rem;
            border-radius: 0.75rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-top: 2rem;
        }

        .activity-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 0;
            border-bottom: 1px solid #e2e8f0;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 2.5rem;
            height: 2.5rem;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1rem;
        }

        .activity-icon.users {
            background: #16a34a;
        }

        .activity-icon.schedules {
            background: #ea580c;
        }

        .activity-icon.tasks {
            background: #7c3aed;
        }

        .activity-content h4 {
            margin-bottom: 0.25rem;
            color: #1e293b;
        }

        .activity-content p {
            color: #64748b;
            font-size: 0.875rem;
        }

        .refresh-btn {
            background: none;
            border: none;
            color: #64748b;
            cursor: pointer;
            padding: 0.5rem;
            border-radius: 0.5rem;
            transition: all 0.2s;
        }

        .refresh-btn:hover {
            background: #f1f5f9;
            color: #2563eb;
        }

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 1rem;
            }

            .header-nav {
                flex-wrap: wrap;
                justify-content: center;
            }

            .container {
                padding: 1rem;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .actions-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <h1><i class="fas fa-cog"></i> BSmart Calendar - Admin Dashboard</h1>
        <div class="header-nav">
            <a href="/admin/dashboard" class="nav-link active">Dashboard</a>
            <a href="/admin/users" class="nav-link">Quản lý người dùng</a>
            <a href="/admin/schedules" class="nav-link">Quản lý lịch</a>
            <a href="/schedule/add" class="nav-link">Về lịch</a>
            <a href="/auth/logout" class="nav-link">Đăng xuất</a>
        </div>
    </div>

    <div class="container">
        <div class="stats-grid">
            <div class="stat-card users">
                <div class="stat-title">
                    <i class="fas fa-users"></i>
                    Tổng số người dùng
                </div>
                <div class="stat-value">${userCount}</div>
            </div>
            
            <div class="stat-card schedules">
                <div class="stat-title">
                    <i class="fas fa-calendar"></i>
                    Tổng số lịch cố định
                </div>
                <div class="stat-value">${scheduleCount}</div>
            </div>
            
            <div class="stat-card tasks">
                <div class="stat-title">
                    <i class="fas fa-tasks"></i>
                    Tổng số nhiệm vụ
                </div>
                <div class="stat-value">${taskCount}</div>
            </div>
            
            <div class="stat-card admins">
                <div class="stat-title">
                    <i class="fas fa-user-shield"></i>
                    Người dùng Admin
                </div>
                <div class="stat-value">${adminCount}</div>
            </div>
        </div>

        <div class="actions-grid">
            <div class="action-card">
                <h3><i class="fas fa-users"></i> Quản lý người dùng</h3>
                <p>Xem danh sách, chỉnh sửa quyền và xóa người dùng</p>
                <a href="/admin/users" class="btn btn-primary">
                    <i class="fas fa-list"></i> Xem danh sách
                </a>
                <button class="btn btn-secondary" onclick="refreshStats()">
                    <i class="fas fa-sync"></i> Làm mới
                </button>
            </div>

            <div class="action-card">
                <h3><i class="fas fa-calendar"></i> Quản lý lịch</h3>
                <p>Xem và quản lý tất cả lịch cố định trong hệ thống</p>
                <a href="/admin/schedules" class="btn btn-primary">
                    <i class="fas fa-list"></i> Xem danh sách
                </a>
                <button class="btn btn-secondary" onclick="refreshStats()">
                    <i class="fas fa-sync"></i> Làm mới
                </button>
            </div>

            <div class="action-card">
                <h3><i class="fas fa-chart-bar"></i> Thống kê hệ thống</h3>
                <p>Xem các thống kê chi tiết về hoạt động hệ thống</p>
                <button class="btn btn-success" onclick="showDetailedStats()">
                    <i class="fas fa-chart-line"></i> Xem thống kê
                </button>
                <button class="btn btn-secondary" onclick="exportData()">
                    <i class="fas fa-download"></i> Xuất dữ liệu
                </button>
            </div>

            <div class="action-card">
                <h3><i class="fas fa-cog"></i> Cài đặt hệ thống</h3>
                <p>Cấu hình các thông số và tùy chọn hệ thống</p>
                <button class="btn btn-primary" onclick="openSystemSettings()">
                    <i class="fas fa-wrench"></i> Cài đặt
                </button>
                <button class="btn btn-secondary" onclick="backupSystem()">
                    <i class="fas fa-database"></i> Sao lưu
                </button>
            </div>
        </div>

        <div class="recent-activity">
            <h3><i class="fas fa-clock"></i> Hoạt động gần đây</h3>
            <div class="activity-item">
                <div class="activity-icon users">
                    <i class="fas fa-user-plus"></i>
                </div>
                <div class="activity-content">
                    <h4>Người dùng mới đăng ký</h4>
                    <p>${userRoleCount} người dùng thường đã đăng ký</p>
                </div>
            </div>
            <div class="activity-item">
                <div class="activity-icon schedules">
                    <i class="fas fa-calendar-plus"></i>
                </div>
                <div class="activity-content">
                    <h4>Lịch được tạo</h4>
                    <p>${scheduleCount} lịch cố định đã được tạo</p>
                </div>
            </div>
            <div class="activity-item">
                <div class="activity-icon tasks">
                    <i class="fas fa-tasks"></i>
                </div>
                <div class="activity-content">
                    <h4>Nhiệm vụ được quản lý</h4>
                    <p>${taskCount} nhiệm vụ đã được tạo</p>
                </div>
            </div>
        </div>
    </div>

    <script>
        function refreshStats() {
            fetch('/admin/stats')
                .then(response => response.json())
                .then(data => {
                    // Update stats display
                    document.querySelector('.stat-card.users .stat-value').textContent = data.totalUsers;
                    document.querySelector('.stat-card.schedules .stat-value').textContent = data.totalSchedules;
                    document.querySelector('.stat-card.tasks .stat-value').textContent = data.totalTasks;
                    document.querySelector('.stat-card.admins .stat-value').textContent = data.adminUsers;
                    
                    // Show success message
                    showNotification('Thống kê đã được cập nhật!', 'success');
                })
                .catch(error => {
                    showNotification('Lỗi khi cập nhật thống kê', 'error');
                });
        }

        function showDetailedStats() {
            alert('Tính năng thống kê chi tiết sẽ được cập nhật sớm!');
        }

        function exportData() {
            alert('Tính năng xuất dữ liệu sẽ được cập nhật sớm!');
        }

        function openSystemSettings() {
            alert('Tính năng cài đặt hệ thống sẽ được cập nhật sớm!');
        }

        function backupSystem() {
            alert('Tính năng sao lưu hệ thống sẽ được cập nhật sớm!');
        }

        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 1rem 1.5rem;
                border-radius: 0.5rem;
                color: white;
                font-weight: 500;
                z-index: 1000;
                animation: slideIn 0.3s ease;
            `;
            
            if (type === 'success') {
                notification.style.background = '#16a34a';
            } else {
                notification.style.background = '#dc2626';
            }
            
            notification.textContent = message;
            document.body.appendChild(notification);
            
            setTimeout(() => {
                notification.remove();
            }, 3000);
        }

        // Auto refresh stats every 30 seconds
        setInterval(refreshStats, 30000);
    </script>
</body>
</html>


