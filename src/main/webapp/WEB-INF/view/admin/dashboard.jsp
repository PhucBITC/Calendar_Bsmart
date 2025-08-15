<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>System Management - B-Smart</title>
        <link rel="stylesheet" href="/client/css/index.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
            integrity="sha512-DxV+EoADOkOygM4IR9yXP8Sb2qwgidEmeqAEmDKIOfPRQZOWbXCzLC6vjbZyy0vPisbH2SyW27+ddLVCN+OMzQ=="
            crossorigin="anonymous" referrerpolicy="no-referrer" />
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
                overflow-x: hidden;
            }

            .admin-container {
                display: flex;
                min-height: 100vh;
                position: relative;
            }

            /* Mobile Menu Toggle */
            .mobile-menu-toggle {
                display: none;
                position: fixed;
                top: 20px;
                left: 20px;
                z-index: 1001;
                background: white;
                border: none;
                border-radius: 8px;
                padding: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                cursor: pointer;
                transition: all 0.3s ease;
            }

            .mobile-menu-toggle:hover {
                background: #f8f9fa;
                transform: scale(1.05);
            }

            .hamburger {
                width: 24px;
                height: 3px;
                background: #2c3e50;
                position: relative;
                transition: all 0.3s ease;
            }

            .hamburger::before,
            .hamburger::after {
                content: '';
                position: absolute;
                width: 24px;
                height: 3px;
                background: #2c3e50;
                transition: all 0.3s ease;
            }

            .hamburger::before {
                top: -8px;
            }

            .hamburger::after {
                bottom: -8px;
            }

            .mobile-menu-toggle.active .hamburger {
                background: transparent;
            }

            .mobile-menu-toggle.active .hamburger::before {
                transform: rotate(45deg);
                top: 0;
            }

            .mobile-menu-toggle.active .hamburger::after {
                transform: rotate(-45deg);
                bottom: 0;
            }

            /* Overlay for mobile */
            .mobile-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                z-index: 999;
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .mobile-overlay.active {
                opacity: 1;
            }

            /* Sidebar */
            .admin-sidebar {
                width: 280px;
                background: white;
                box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
                position: fixed;
                height: 100vh;
                overflow-y: auto;
                z-index: 1000;
                transition: transform 0.3s ease;
                left: 0;
                top: 0;
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
                transition: margin-left 0.3s ease;
            }

            .main-header {
                background: white;
                padding: 25px 30px;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
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
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
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

            .stat-icon.users {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }

            .stat-icon.tasks {
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            }

            .stat-icon.schedules {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            }

            .stat-icon.system {
                background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            }

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
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
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

            /* Responsive Design */
            @media (max-width: 1024px) {
                .stats-grid {
                    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                    gap: 20px;
                }

                .actions-grid {
                    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                    gap: 15px;
                }

                .admin-main {
                    padding: 25px;
                }
            }

            @media (max-width: 768px) {
                .mobile-menu-toggle {
                    display: block;
                }

                .mobile-overlay {
                    display: block;
                }

                .admin-sidebar {
                    transform: translateX(-100%);
                    width: 280px;
                }

                .admin-sidebar.mobile-open {
                    transform: translateX(0);
                }

                .admin-main {
                    margin-left: 0;
                    padding: 20px;
                    padding-top: 80px;
                }

                .main-header {
                    padding: 20px;
                    margin-bottom: 20px;
                }

                .main-header h1 {
                    font-size: 28px;
                }

                .stats-grid {
                    grid-template-columns: 1fr;
                    gap: 15px;
                }

                .stat-card {
                    padding: 25px;
                }

                .stat-number {
                    font-size: 32px;
                }

                .actions-grid {
                    grid-template-columns: 1fr;
                    gap: 15px;
                }

                .action-btn {
                    padding: 18px;
                }

                .quick-actions {
                    padding: 25px;
                }

                .section-title {
                    font-size: 22px;
                }
            }

            @media (max-width: 480px) {
                .admin-main {
                    padding: 15px;
                    padding-top: 70px;
                }

                .main-header {
                    padding: 15px;
                }

                .main-header h1 {
                    font-size: 24px;
                }

                .main-header p {
                    font-size: 14px;
                }

                .stat-card {
                    padding: 20px;
                }

                .stat-header {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 10px;
                }

                .stat-icon {
                    width: 40px;
                    height: 40px;
                    font-size: 20px;
                }

                .stat-number {
                    font-size: 28px;
                }

                .action-btn {
                    padding: 15px;
                    font-size: 14px;
                }

                .action-btn i {
                    font-size: 18px;
                }

                .quick-actions {
                    padding: 20px;
                }

                .section-title {
                    font-size: 20px;
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

            /* Smooth scrolling for sidebar */
            .admin-sidebar {
                scrollbar-width: thin;
                scrollbar-color: #cbd5e0 #f7fafc;
            }

            .admin-sidebar::-webkit-scrollbar {
                width: 6px;
            }

            .admin-sidebar::-webkit-scrollbar-track {
                background: #f7fafc;
            }

            .admin-sidebar::-webkit-scrollbar-thumb {
                background: #cbd5e0;
                border-radius: 3px;
            }

            .admin-sidebar::-webkit-scrollbar-thumb:hover {
                background: #a0aec0;
            }
        </style>
    </head>

    <body>
        <!-- Mobile Menu Toggle -->
        <button class="mobile-menu-toggle" id="mobileMenuToggle">
            <i class="fa-solid fa-bars"></i>
        </button>

        <!-- Mobile Overlay -->
        <div class="mobile-overlay" id="mobileOverlay"></div>

        <div class="admin-container">
            <!-- Sidebar -->
            <div class="admin-sidebar" id="adminSidebar">
                <div class="sidebar-header">
                    <h2>B-Smart</h2>
                    <p>System Management</p>
                </div>

                <nav class="sidebar-nav">
                    <div class="nav-section">
                        <h3>Main Management</h3>
                        <a href="/admin/dashboard" class="nav-item active">
                            <i>📊</i>Dashboard
                        </a>
                        <a href="/admin/users" class="nav-item">
                            <i>👥</i>User Management
                        </a>
                        <a href="/admin/tasks" class="nav-item">
                            <i>📋</i>Task Management
                        </a>
                        <a href="/admin/schedules" class="nav-item">
                            <i>📅</i>Schedule Management
                        </a>
                    </div>

                    <div class="nav-section">
                        <h3>Reports</h3>
                        <a href="/admin/reports" class="nav-item">
                            <i>📈</i>Statistics Report
                        </a>
                        <a href="/admin/analytics" class="nav-item">
                            <i>📊</i>Data Analytics
                        </a>
                    </div>

                    <div class="nav-section">
                        <h3>System</h3>
                        <a href="/admin/settings" class="nav-item">
                            <i>⚙️</i>Settings
                        </a>
                        <a href="/admin/logs" class="nav-item">
                            <i>📝</i>System Logs
                        </a>
                    </div>
                </nav>
            </div>

            <!-- Main Content -->
            <div class="admin-main">
                <!-- Header -->
                <div class="main-header">
                    <h1>Dashboard</h1>
                    <p>Welcome to the B-Smart management system</p>
                </div>

                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Total Users</span>
                            <div class="stat-icon users">👥</div>
                        </div>
                        <div class="stat-number">${totalUsers}</div>
                        <div class="stat-change positive">
                            <span>↗ +${userGrowthPercent}%</span>
                            <span style="margin-left: 8px;">compared to last month</span>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Ongoing Tasks</span>
                            <div class="stat-icon tasks">📋</div>
                        </div>
                        <div class="stat-number">${totalTasks}</div>
                        <div class="stat-change positive">
                            <span>↗ +${taskGrowthPercent}%</span>
                            <span style="margin-left: 8px;">compared to last week</span>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Schedules Created</span>
                            <div class="stat-icon schedules">📅</div>
                        </div>
                        <div class="stat-number">${totalSchedules}</div>
                        <div class="stat-change positive">
                            <span>↗ +${scheduleGrowthPercent}%</span>
                            <span style="margin-left: 8px;">compared to last month</span>
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">System Performance</span>
                            <div class="stat-icon system">⚡</div>
                        </div>
                        <div class="stat-number">${systemPerformance}%</div>
                        <div class="stat-change positive">
                            <span>↗ +2%</span>
                            <span style="margin-left: 8px;">compared to last week</span>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="quick-actions">
                    <h2 class="section-title">
                        <i>⚡</i>Quick Actions
                    </h2>
                    <div class="actions-grid">
                        <a href="/admin/users/add" class="action-btn">
                            <i>➕</i>
                            Add New User
                        </a>
                        <a href="/admin/tasks/add" class="action-btn">
                            <i>📝</i>
                            Create New Task
                        </a>
                        <a href="/admin/schedules/add" class="action-btn">
                            <i>📅</i>
                            Create New Schedule
                        </a>
                        <a href="/admin/reports" class="action-btn">
                            <i>📊</i>
                            View Reports
                        </a>
                        <a href="/admin/settings" class="action-btn">
                            <i>⚙️</i>
                            System Settings
                        </a>
                        <a href="/admin/backup" class="action-btn">
                            <i>💾</i>
                            Backup Data
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Mobile menu functionality
            document.addEventListener('DOMContentLoaded', function () {
                const mobileMenuToggle = document.getElementById('mobileMenuToggle');
                const adminSidebar = document.getElementById('adminSidebar');
                const mobileOverlay = document.getElementById('mobileOverlay');

                // Toggle mobile menu
                function toggleMobileMenu() {
                    mobileMenuToggle.classList.toggle('active');
                    adminSidebar.classList.toggle('mobile-open');
                    mobileOverlay.classList.toggle('active');
                    document.body.style.overflow = adminSidebar.classList.contains('mobile-open') ? 'hidden' : '';
                }

                // Close mobile menu
                function closeMobileMenu() {
                    mobileMenuToggle.classList.remove('active');
                    adminSidebar.classList.remove('mobile-open');
                    mobileOverlay.classList.remove('active');
                    document.body.style.overflow = '';
                }

                // Event listeners
                mobileMenuToggle.addEventListener('click', toggleMobileMenu);
                mobileOverlay.addEventListener('click', closeMobileMenu);

                // Close menu when clicking on nav items (mobile)
                const navItems = document.querySelectorAll('.nav-item');
                navItems.forEach(item => {
                    item.addEventListener('click', function () {
                        // Remove active class from all nav items
                        navItems.forEach(nav => nav.classList.remove('active'));
                        // Add active class to clicked item
                        this.classList.add('active');

                        // Close mobile menu if on mobile
                        if (window.innerWidth <= 768) {
                            closeMobileMenu();
                        }
                    });
                });

                // Handle window resize
                window.addEventListener('resize', function () {
                    if (window.innerWidth > 768) {
                        closeMobileMenu();
                    }
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

                // Smooth scroll for sidebar on mobile
                if (window.innerWidth <= 768) {
                    adminSidebar.addEventListener('touchstart', function (e) {
                        this.style.overflowY = 'auto';
                    });
                }
            });
        </script>
    </body>

    </html>