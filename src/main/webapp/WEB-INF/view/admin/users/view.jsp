<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>View User - B-Smart</title>
                <link rel="stylesheet" href="/client/css/index.css" />
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" />
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
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
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

                    .header-actions {
                        display: flex;
                        gap: 15px;
                    }

                    .btn {
                        padding: 12px 24px;
                        border: none;
                        border-radius: 8px;
                        text-decoration: none;
                        font-weight: 600;
                        transition: all 0.3s ease;
                        cursor: pointer;
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                    }

                    .btn-primary {
                        background: #3498db;
                        color: white;
                    }

                    .btn-primary:hover {
                        background: #2980b9;
                        transform: translateY(-2px);
                        box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
                    }

                    .btn-secondary {
                        background: #95a5a6;
                        color: white;
                    }

                    .btn-secondary:hover {
                        background: #7f8c8d;
                        transform: translateY(-2px);
                    }

                    .btn-success {
                        background: #27ae60;
                        color: white;
                    }

                    .btn-success:hover {
                        background: #229954;
                        transform: translateY(-2px);
                    }

                    .btn-warning {
                        background: #f39c12;
                        color: white;
                    }

                    .btn-warning:hover {
                        background: #e67e22;
                        transform: translateY(-2px);
                    }

                    /* User Profile */
                    .user-profile {
                        background: white;
                        border-radius: 15px;
                        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
                        overflow: hidden;
                    }

                    .profile-header {
                        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                        padding: 40px 30px;
                        text-align: center;
                        color: white;
                    }

                    .profile-avatar {
                        width: 120px;
                        height: 120px;
                        border-radius: 50%;
                        background: rgba(255, 255, 255, 0.2);
                        color: white;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-weight: 700;
                        font-size: 48px;
                        margin: 0 auto 20px;
                        border: 4px solid rgba(255, 255, 255, 0.3);
                    }

                    .profile-name {
                        font-size: 28px;
                        font-weight: 700;
                        margin-bottom: 8px;
                    }

                    .profile-username {
                        font-size: 16px;
                        opacity: 0.9;
                        margin-bottom: 15px;
                    }

                    .profile-status {
                        display: inline-block;
                        padding: 6px 16px;
                        border-radius: 20px;
                        font-size: 14px;
                        font-weight: 600;
                        text-transform: uppercase;
                    }

                    .status-active {
                        background: rgba(39, 174, 96, 0.2);
                        color: #27ae60;
                    }

                    .status-inactive {
                        background: rgba(231, 76, 60, 0.2);
                        color: #e74c3c;
                    }

                    .profile-content {
                        padding: 30px;
                    }

                    .info-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                        gap: 30px;
                        margin-bottom: 30px;
                    }

                    .info-section {
                        background: #f8f9fa;
                        padding: 25px;
                        border-radius: 12px;
                        border-left: 4px solid #3498db;
                    }

                    .info-section h3 {
                        color: #2c3e50;
                        font-size: 18px;
                        font-weight: 600;
                        margin-bottom: 20px;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .info-section h3 i {
                        color: #3498db;
                    }

                    .info-item {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 12px 0;
                        border-bottom: 1px solid #e9ecef;
                    }

                    .info-item:last-child {
                        border-bottom: none;
                    }

                    .info-label {
                        color: #7f8c8d;
                        font-weight: 600;
                        font-size: 14px;
                    }

                    .info-value {
                        color: #2c3e50;
                        font-weight: 500;
                    }

                    .role-badge {
                        padding: 6px 12px;
                        border-radius: 20px;
                        font-size: 12px;
                        font-weight: 600;
                        text-transform: uppercase;
                    }

                    .role-admin {
                        background: #fff3cd;
                        color: #856404;
                    }

                    .role-user {
                        background: #d1ecf1;
                        color: #0c5460;
                    }

                    /* Statistics */
                    .stats-section {
                        background: #f8f9fa;
                        padding: 25px;
                        border-radius: 12px;
                        margin-top: 30px;
                    }

                    .stats-section h3 {
                        color: #2c3e50;
                        font-size: 18px;
                        font-weight: 600;
                        margin-bottom: 20px;
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .stats-section h3 i {
                        color: #3498db;
                    }

                    .stats-grid {
                        display: grid;
                        grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                        gap: 20px;
                    }

                    .stat-card {
                        background: white;
                        padding: 20px;
                        border-radius: 10px;
                        text-align: center;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
                    }

                    .stat-number {
                        font-size: 32px;
                        font-weight: 700;
                        color: #3498db;
                        margin-bottom: 8px;
                    }

                    .stat-label {
                        color: #7f8c8d;
                        font-size: 14px;
                        font-weight: 600;
                    }

                    /* Responsive Design */
                    @media (max-width: 1024px) {
                        .admin-main {
                            padding: 25px;
                        }

                        .main-header {
                            flex-direction: column;
                            gap: 20px;
                            align-items: flex-start;
                        }

                        .info-grid {
                            grid-template-columns: 1fr;
                            gap: 20px;
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

                        .profile-header {
                            padding: 30px 20px;
                        }

                        .profile-avatar {
                            width: 100px;
                            height: 100px;
                            font-size: 40px;
                        }

                        .profile-name {
                            font-size: 24px;
                        }

                        .profile-content {
                            padding: 20px;
                        }

                        .header-actions {
                            flex-direction: column;
                            width: 100%;
                        }

                        .btn {
                            width: 100%;
                            justify-content: center;
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

                        .profile-header {
                            padding: 20px 15px;
                        }

                        .profile-avatar {
                            width: 80px;
                            height: 80px;
                            font-size: 32px;
                        }

                        .profile-name {
                            font-size: 20px;
                        }

                        .profile-content {
                            padding: 15px;
                        }

                        .stats-grid {
                            grid-template-columns: 1fr;
                        }
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
                                <a href="/admin/dashboard" class="nav-item">
                                    <i>📊</i>Dashboard
                                </a>
                                <a href="/admin/users" class="nav-item active">
                                    <i>👥</i>User Management
                                </a>
                                <a href="/admin/tasks" class="nav-item">
                                    <i>📋</i>Task Management
                                </a>
                                <a href="/admin/schedules" class="nav-item">

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
                            <div>
                                <h1>User Details</h1>
                                <p>View detailed information about the user</p>
                            </div>
                            <div class="header-actions">
                                <a href="/admin/users/edit/${user.id}" class="btn btn-warning">
                                    <i class="fa-solid fa-edit"></i>
                                    Edit User
                                </a>
                                <a href="/admin/users" class="btn btn-secondary">
                                    <i class="fa-solid fa-arrow-left"></i>
                                    Back to Users
                                </a>
                            </div>
                        </div>

                        <!-- User Profile -->
                        <div class="user-profile">
                            <div class="profile-header">
                                <div class="profile-avatar">
                                    ${user.fullName != null ? user.fullName.substring(0, 1).toUpperCase() :
                                    user.username.substring(0, 1).toUpperCase()}
                                </div>
                                <div class="profile-name">${user.fullName != null ? user.fullName : 'N/A'}</div>
                                <div class="profile-username">@${user.username}</div>
                                <div class="profile-status ${user.isActive() ? 'status-active' : 'status-inactive'}">
                                    ${user.isActive() ? 'Active' : 'Inactive'}
                                </div>
                            </div>

                            <div class="profile-content">
                                <div class="info-grid">
                                    <div class="info-section">
                                        <h3>
                                            <i class="fa-solid fa-user"></i>
                                            Basic Information
                                        </h3>
                                        <div class="info-item">
                                            <span class="info-label">Username:</span>
                                            <span class="info-value">${user.username}</span>
                                        </div>
                                        <div class="info-item">
                                            <span class="info-label">Email:</span>
                                            <span class="info-value">${user.email}</span>
                                        </div>
                                        <div class="info-item">
                                            <span class="info-label">Full Name:</span>
                                            <span class="info-value">${user.fullName != null ? user.fullName :
                                                'N/A'}</span>
                                        </div>
                                        <div class="info-item">
                                            <span class="info-label">Phone Number:</span>
                                            <span class="info-value">${user.phoneNumber != null ? user.phoneNumber :
                                                'N/A'}</span>
                                        </div>
                                    </div>

                                    <div class="info-section">
                                        <h3>
                                            <i class="fa-solid fa-shield-alt"></i>
                                            Account Details
                                        </h3>
                                        <div class="info-item">
                                            <span class="info-label">Role:</span>
                                            <span class="role-badge role-${user.role.name().toLowerCase()}">
                                                ${user.role.name()}
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <span class="info-label">Status:</span>
                                            <span
                                                class="info-value ${user.isActive() ? 'status-active' : 'status-inactive'}">
                                                ${user.isActive() ? 'Active' : 'Inactive'}
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <span class="info-label">Created:</span>
                                            <span class="info-value">
                                                <c:choose>
                                                    <c:when test="${user.createdAt != null}">
                                                        ${user.createdAt}
                                                    </c:when>
                                                    <c:otherwise>
                                                        N/A
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <div class="info-item">
                                            <span class="info-label">Last Updated:</span>
                                            <span class="info-value">
                                                <c:choose>
                                                    <c:when test="${user.updatedAt != null}">
                                                        ${user.updatedAt}
                                                    </c:when>
                                                    <c:otherwise>
                                                        N/A
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                    </div>
                                </div>

                                <!-- Statistics -->
                                <div class="stats-section">
                                    <h3>
                                        <i class="fa-solid fa-chart-bar"></i>
                                        User Statistics
                                    </h3>
                                    <div class="stats-grid">
                                        <div class="stat-card">
                                            <div class="stat-number">${taskCount}</div>
                                            <div class="stat-label">Total Tasks</div>
                                        </div>
                                        <div class="stat-card">
                                            <div class="stat-number">${scheduleCount}</div>
                                            <div class="stat-label">Total Schedules</div>
                                        </div>
                                    </div>
                                </div>
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