<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>

<head>
    <title>Quản lý hệ thống - B-Smart</title>
    <link rel="stylesheet" href="/client/css/index.css" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            color: #333;
        }

        .admin-container {
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar */
        .admin-sidebar {
            width: 280px;
            background: white;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            position: fixed;
            height: 100vh;
            overflow-y: auto;
        }

        .sidebar-header {
            padding: 30px 25px;
            border-bottom: 1px solid #e8e8e8;
            text-align: center;
        }

        .sidebar-header h2 {
            color: #2c3e50;
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .sidebar-header p {
            color: #7f8c8d;
            font-size: 14px;
        }

        .sidebar-nav {
            padding: 20px 0;
        }

        .nav-section {
            margin-bottom: 30px;
        }

        .nav-section h3 {
            color: #95a5a6;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 0 25px 10px;
            font-weight: 600;
        }

        .nav-item {
            display: block;
            padding: 15px 25px;
            color: #34495e;
            text-decoration: none;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
            position: relative;
        }

        .nav-item:hover {
            background: #f8f9fa;
            color: #3498db;
            border-left-color: #3498db;
            transform: translateX(5px);
        }

        .nav-item.active {
            background: #ecf0f1;
            color: #3498db;
            border-left-color: #3498db;
        }

        .nav-item i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
        }

        /* Main Content */
        .admin-main {
            flex: 1;
            margin-left: 280px;
            padding: 30px;
        }

        .main-header {
            background: white;
            padding: 25px 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }

        .main-header h1 {
            color: #2c3e50;
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .main-header p {
            color: #7f8c8d;
            font-size: 16px;
        }

        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #3498db, #2980b9);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .stat-title {
            color: #7f8c8d;
            font-size: 14px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
        }

        .stat-icon.users { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .stat-icon.tasks { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .stat-icon.schedules { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
        .stat-icon.system { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); }

        .stat-number {
            font-size: 36px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 8px;
        }

        .stat-change {
            display: flex;
            align-items: center;
            font-size: 14px;
        }

        .stat-change.positive {
            color: #27ae60;
        }

        .stat-change.negative {
            color: #e74c3c;
        }

        /* Quick Actions */
        .quick-actions {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }

        .section-title {
            color: #2c3e50;
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 12px;
            color: #3498db;
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }

        .action-btn {
            display: flex;
            align-items: center;
            padding: 20px;
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-radius: 12px;
            text-decoration: none;
            color: #495057;
            transition: all 0.3s ease;
            font-weight: 500;
        }

        .action-btn:hover {
            background: #3498db;
            color: white;
            border-color: #3498db;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
        }

        .action-btn i {
            margin-right: 12px;
            font-size: 20px;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .admin-sidebar {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }

            .admin-sidebar.open {
                transform: translateX(0);
            }

            .admin-main {
                margin-left: 0;
                padding: 20px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .actions-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Icons */
        .icon {
            display: inline-block;
            width: 1em;
            height: 1em;
            stroke-width: 0;
            stroke: currentColor;
            fill: currentColor;
        }
    </style>
</head>

<body>
    <div class="admin-container">
        <!-- Sidebar -->
        <div class="admin-sidebar">
            <div class="sidebar-header">
                <h2>B-Smart</h2>
                <p>Quản lý hệ thống</p>
            </div>
            
            <nav class="sidebar-nav">
                <div class="nav-section">
                    <h3>Quản lý chính</h3>
                    <a href="/admin/dashboard" class="nav-item active">
                        <i>📊</i>Dashboard
                    </a>
                    <a href="/admin/users" class="nav-item">
                        <i>👥</i>Quản lý người dùng
                    </a>
                    <a href="/admin/tasks" class="nav-item">
                        <i>📋</i>Quản lý công việc
                    </a>
                    <a href="/admin/schedules" class="nav-item">
                        <i>📅</i>Quản lý lịch
                    </a>
                </div>
                
                <div class="nav-section">
                    <h3>Báo cáo</h3>
                    <a href="/admin/reports" class="nav-item">
                        <i>📈</i>Báo cáo thống kê
                    </a>
                    <a href="/admin/analytics" class="nav-item">
                        <i>📊</i>Phân tích dữ liệu
                    </a>
                </div>
                
                <div class="nav-section">
                    <h3>Hệ thống</h3>
                    <a href="/admin/settings" class="nav-item">
                        <i>⚙️</i>Cài đặt
                    </a>
                    <a href="/admin/logs" class="nav-item">
                        <i>📝</i>Nhật ký hệ thống
                    </a>
                </div>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="admin-main">
            <!-- Header -->
            <div class="main-header">
                <h1>Dashboard</h1>
                <p>Chào mừng bạn đến với hệ thống quản lý B-Smart</p>
            </div>

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-header">
                        <span class="stat-title">Tổng người dùng</span>
                        <div class="stat-icon users">👥</div>
                    </div>
                    <div class="stat-number">${totalUsers}</div>
                    <div class="stat-change positive">
                        <span>↗ +${userGrowthPercent}%</span>
                        <span style="margin-left: 8px;">so với tháng trước</span>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <span class="stat-title">Công việc đang thực hiện</span>
                        <div class="stat-icon tasks">📋</div>
                    </div>
                    <div class="stat-number">${totalTasks}</div>
                    <div class="stat-change positive">
                        <span>↗ +${taskGrowthPercent}%</span>
                        <span style="margin-left: 8px;">so với tuần trước</span>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <span class="stat-title">Lịch đã tạo</span>
                        <div class="stat-icon schedules">📅</div>
                    </div>
                    <div class="stat-number">${totalSchedules}</div>
                    <div class="stat-change positive">
                        <span>↗ +${scheduleGrowthPercent}%</span>
                        <span style="margin-left: 8px;">so với tháng trước</span>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <span class="stat-title">Hiệu suất hệ thống</span>
                        <div class="stat-icon system">⚡</div>
                    </div>
                    <div class="stat-number">${systemPerformance}%</div>
                    <div class="stat-change positive">
                        <span>↗ +2%</span>
                        <span style="margin-left: 8px;">so với tuần trước</span>
                    </div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <h2 class="section-title">
                    <i>⚡</i>Thao tác nhanh
                </h2>
                <div class="actions-grid">
                    <a href="/admin/users/add" class="action-btn">
                        <i>➕</i>
                        Thêm người dùng mới
                    </a>
                    <a href="/admin/tasks/add" class="action-btn">
                        <i>📝</i>
                        Tạo công việc mới
                    </a>
                    <a href="/admin/schedules/add" class="action-btn">
                        <i>📅</i>
                        Tạo lịch mới
                    </a>
                    <a href="/admin/reports" class="action-btn">
                        <i>📊</i>
                        Xem báo cáo
                    </a>
                    <a href="/admin/settings" class="action-btn">
                        <i>⚙️</i>
                        Cài đặt hệ thống
                    </a>
                    <a href="/admin/backup" class="action-btn">
                        <i>💾</i>
                        Sao lưu dữ liệu
                    </a>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Add hover effects and interactions
        document.addEventListener('DOMContentLoaded', function() {
            // Add click handlers for navigation
            const navItems = document.querySelectorAll('.nav-item');
            navItems.forEach(item => {
                item.addEventListener('click', function() {
                    navItems.forEach(nav => nav.classList.remove('active'));
                    this.classList.add('active');
                });
            });

            // Add animation to stat cards
            const statCards = document.querySelectorAll('.stat-card');
            statCards.forEach((card, index) => {
                card.style.animationDelay = `${index * 0.1}s`;
                card.style.animation = 'fadeInUp 0.6s ease forwards';
            });

            // Add CSS animation
            const style = document.createElement('style');
            style.textContent = `
                @keyframes fadeInUp {
                    from {
                        opacity: 0;
                        transform: translateY(30px);
                    }
                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }
            `;
            document.head.appendChild(style);
        });
    </script>
</body>

</html>