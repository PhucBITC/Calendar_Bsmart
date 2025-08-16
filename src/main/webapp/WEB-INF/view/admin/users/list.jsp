<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>

<head>
    <title>User Management - B-Smart</title>
    <link rel="stylesheet" href="/client/css/index.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" />
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

        .btn-danger {
            background: #e74c3c;
            color: white;
        }

        .btn-danger:hover {
            background: #c0392b;
            transform: translateY(-2px);
        }

        .btn-sm {
            padding: 8px 16px;
            font-size: 14px;
        }

        /* Alerts */
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            border-left: 4px solid;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left-color: #27ae60;
        }

        .alert-danger {
            background: #f8d7da;
            color: #721c24;
            border-left-color: #e74c3c;
        }

        /* Search and Filter */
        .search-filter {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            margin-bottom: 25px;
        }

        .search-filter form {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }

        .form-group {
            flex: 1;
            min-width: 200px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #2c3e50;
            font-weight: 600;
        }

        .form-control {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        /* Users Table */
        .users-table {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        .table-header {
            padding: 20px 25px;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .table-header h3 {
            color: #2c3e50;
            font-size: 20px;
            font-weight: 600;
        }

        .table-container {
            overflow-x: auto;
        }

        .table {
            width: 100%;
            border-collapse: collapse;
        }

        .table th {
            background: #f8f9fa;
            padding: 15px 20px;
            text-align: left;
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 2px solid #e9ecef;
        }

        .table td {
            padding: 15px 20px;
            border-bottom: 1px solid #e9ecef;
            vertical-align: middle;
        }

        .table tbody tr:hover {
            background: #f8f9fa;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #3498db;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 16px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .user-details h4 {
            color: #2c3e50;
            font-weight: 600;
            margin-bottom: 4px;
        }

        .user-details p {
            color: #7f8c8d;
            font-size: 14px;
            margin: 0;
        }

        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-active {
            background: #d4edda;
            color: #155724;
        }

        .status-inactive {
            background: #f8d7da;
            color: #721c24;
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

        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            align-items: center;
        }

        .action-buttons .btn {
            white-space: nowrap;
            min-width: 80px;
        }

        .action-buttons form {
            margin: 0;
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

            .search-filter form {
                flex-direction: column;
                align-items: stretch;
            }

            .form-group {
                min-width: auto;
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

            .search-filter {
                padding: 20px;
            }

            .table-header {
                padding: 15px 20px;
            }

            .table th,
            .table td {
                padding: 12px 15px;
            }

            .action-buttons {
                flex-direction: column;
                gap: 5px;
            }

            .btn-sm {
                width: 100%;
                justify-content: center;
                padding: 10px 12px;
                font-size: 13px;
            }

            .action-buttons form {
                width: 100%;
            }

            .action-buttons form .btn {
                width: 100%;
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

            .search-filter {
                padding: 15px;
            }

            .table-container {
                font-size: 14px;
            }

            .table th,
            .table td {
                padding: 10px 12px;
            }

            .user-info {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
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
                <div>
                    <h1>User Management</h1>
                    <p>Manage system users and their permissions</p>
                </div>
                <div class="header-actions">
                    <a href="/admin/users/add" class="btn btn-primary">
                        <i class="fa-solid fa-plus"></i>
                        Add New User
                    </a>
                </div>
            </div>

            <!-- Alerts -->
            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fa-solid fa-check-circle"></i>
                    ${success}
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fa-solid fa-exclamation-triangle"></i>
                    ${error}
                </div>
            </c:if>

            <!-- Search and Filter -->
            <div class="search-filter">
                <form method="GET" action="/admin/users">
                    <div class="form-group">
                        <label for="search">Search Users</label>
                        <input type="text" id="search" name="search" class="form-control" 
                               placeholder="Search by username, email, or full name..." 
                               value="${param.search}">
                    </div>
                    <div class="form-group">
                        <label for="role">Role</label>
                        <select id="role" name="role" class="form-control">
                            <option value="">All Roles</option>
                            <option value="ADMIN" ${param.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                            <option value="USER" ${param.role == 'USER' ? 'selected' : ''}>User</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="status">Status</label>
                        <select id="status" name="status" class="form-control">
                            <option value="">All Status</option>
                            <option value="active" ${param.status == 'active' ? 'selected' : ''}>Active</option>
                            <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Inactive</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>&nbsp;</label>
                        <div style="display: flex; gap: 10px;">
                            <button type="submit" class="btn btn-primary">
                                <i class="fa-solid fa-search"></i>
                                Search
                            </button>
                            <a href="/admin/users" class="btn btn-warning">
                                <i class="fa-solid fa-times"></i>
                                Clear
                            </a>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Users Table -->
            <div class="users-table">
                <div class="table-header">
                    <h3>Users List (${users.size()} user${users.size() != 1 ? 's' : ''})</h3>
                    <c:if test="${not empty param.search or not empty param.role or not empty param.status}">
                        <div style="color: #7f8c8d; font-size: 14px;">
                            <i class="fa-solid fa-filter"></i>
                            Filtered results
                        </div>
                    </c:if>
                </div>
                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>User</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Created</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty users}">
                                    <tr>
                                        <td colspan="6" style="text-align: center; padding: 40px 20px;">
                                            <div style="color: #7f8c8d; font-size: 16px;">
                                                <i class="fa-solid fa-users" style="font-size: 48px; margin-bottom: 15px; display: block; opacity: 0.5;"></i>
                                                <p>No users found</p>
                                                <p style="font-size: 14px; margin-top: 10px;">Try adjusting your search criteria or add a new user.</p>
                                            </div>
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="user" items="${users}">
                                        <tr>
                                            <td>
                                                <div class="user-info">
                                                    <div class="user-avatar">
                                                        ${user.fullName != null ? user.fullName.substring(0, 1).toUpperCase() : user.username.substring(0, 1).toUpperCase()}
                                                    </div>
                                                    <div class="user-details">
                                                        <h4>${user.fullName != null ? user.fullName : 'N/A'}</h4>
                                                        <p>@${user.username}</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td>${user.email}</td>
                                            <td>
                                                <span class="role-badge role-${user.role.name().toLowerCase()}">
                                                    ${user.role.name()}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="status-badge ${user.isActive() ? 'status-active' : 'status-inactive'}">
                                                    ${user.isActive() ? 'Active' : 'Inactive'}
                                                </span>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td>
                                                <div class="action-buttons">
                                                    <a href="/admin/users/view/${user.id}" class="btn btn-success btn-sm">
                                                        <i class="fa-solid fa-eye"></i>
                                                        View
                                                    </a>
                                                    <a href="/admin/users/edit/${user.id}" class="btn btn-warning btn-sm">
                                                        <i class="fa-solid fa-edit"></i>
                                                        Edit
                                                    </a>
                                                    <form method="POST" action="/admin/users/toggle-status/${user.id}" 
                                                          style="display: inline;" 
                                                          onsubmit="return confirm('Are you sure you want to ${user.isActive() ? 'deactivate' : 'activate'} this user?')">
                                                        <button type="submit" class="btn ${user.isActive() ? 'btn-warning' : 'btn-success'} btn-sm">
                                                            <i class="fa-solid ${user.isActive() ? 'fa-user-slash' : 'fa-user-check'}"></i>
                                                            ${user.isActive() ? 'Deactivate' : 'Activate'}
                                                        </button>
                                                    </form>
                                                    <form method="POST" action="/admin/users/delete/${user.id}" 
                                                          style="display: inline;" 
                                                          onsubmit="return confirm('Are you sure you want to delete this user? This action cannot be undone.')">
                                                        <button type="submit" class="btn btn-danger btn-sm">
                                                            <i class="fa-solid fa-trash"></i>
                                                            Delete
                                                        </button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
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

            // Auto-submit search form when pressing Enter
            const searchInput = document.getElementById('search');
            if (searchInput) {
                searchInput.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        this.closest('form').submit();
                    }
                });
            }

            // Confirm delete action
            const deleteForms = document.querySelectorAll('form[action*="/delete/"]');
            deleteForms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    if (!confirm('Are you sure you want to delete this user? This action cannot be undone.')) {
                        e.preventDefault();
                    }
                });
            });

            // Confirm toggle status action
            const toggleForms = document.querySelectorAll('form[action*="/toggle-status/"]');
            toggleForms.forEach(form => {
                form.addEventListener('submit', function(e) {
                    const button = this.querySelector('button');
                    const action = button.textContent.trim().toLowerCase();
                    if (!confirm(`Are you sure you want to ${action} this user?`)) {
                        e.preventDefault();
                    }
                });
            });
        });
    </script>
</body>

</html>
