<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>User Management - B-Smart</title>
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" />
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
                    }

                    .container {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 20px;
                    }

                    .header {
                        background: white;
                        padding: 20px;
                        border-radius: 10px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        margin-bottom: 20px;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .header h1 {
                        color: #2c3e50;
                        font-size: 28px;
                    }

                    .btn {
                        padding: 10px 20px;
                        border: none;
                        border-radius: 5px;
                        text-decoration: none;
                        font-weight: 600;
                        cursor: pointer;
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                        transition: all 0.3s ease;
                    }

                    .btn-primary {
                        background: #3498db;
                        color: white;
                    }

                    .btn-primary:hover {
                        background: #2980b9;
                    }

                    .btn-success {
                        background: #27ae60;
                        color: white;
                    }

                    .btn-warning {
                        background: #f39c12;
                        color: white;
                    }

                    .btn-danger {
                        background: #e74c3c;
                        color: white;
                    }

                    .btn-sm {
                        padding: 6px 12px;
                        font-size: 12px;
                    }

                    .search-section {
                        background: white;
                        padding: 20px;
                        border-radius: 10px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        margin-bottom: 20px;
                    }

                    .search-form {
                        display: flex;
                        gap: 15px;
                        align-items: end;
                        flex-wrap: wrap;
                    }

                    .form-group {
                        flex: 1;
                        min-width: 200px;
                    }

                    .form-group label {
                        display: block;
                        margin-bottom: 5px;
                        font-weight: 600;
                        color: #2c3e50;
                    }

                    .form-control {
                        width: 100%;
                        padding: 8px 12px;
                        border: 1px solid #ddd;
                        border-radius: 5px;
                        font-size: 14px;
                    }

                    .table-container {
                        background: white;
                        border-radius: 10px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        overflow: hidden;
                    }

                    .table-header {
                        padding: 20px;
                        border-bottom: 1px solid #eee;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .table {
                        width: 100%;
                        border-collapse: collapse;
                        min-width: 800px;
                    }

                    .table th {
                        background: #f8f9fa;
                        padding: 12px 15px;
                        text-align: left;
                        font-weight: 600;
                        color: #2c3e50;
                        border-bottom: 2px solid #dee2e6;
                    }

                    .table td {
                        padding: 12px 15px;
                        border-bottom: 1px solid #dee2e6;
                        vertical-align: middle;
                    }

                    .table tbody tr:hover {
                        background: #f8f9fa;
                    }

                    .user-avatar {
                        width: 35px;
                        height: 35px;
                        border-radius: 50%;
                        background: #3498db;
                        color: white;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-weight: 600;
                        font-size: 14px;
                    }

                    .user-info {
                        display: flex;
                        align-items: center;
                        gap: 10px;
                    }

                    .user-details h4 {
                        color: #2c3e50;
                        font-weight: 600;
                        margin-bottom: 2px;
                    }

                    .user-details p {
                        color: #7f8c8d;
                        font-size: 12px;
                        margin: 0;
                    }

                    .badge {
                        padding: 4px 8px;
                        border-radius: 12px;
                        font-size: 11px;
                        font-weight: 600;
                        text-transform: uppercase;
                    }

                    .badge-admin {
                        background: #fff3cd;
                        color: #856404;
                    }

                    .badge-user {
                        background: #d1ecf1;
                        color: #0c5460;
                    }

                    .badge-active {
                        background: #d4edda;
                        color: #155724;
                    }

                    .badge-inactive {
                        background: #f8d7da;
                        color: #721c24;
                    }

                    .action-buttons {
                        display: flex;
                        gap: 5px;
                        flex-wrap: wrap;
                        min-width: 200px;
                    }

                    .action-buttons .btn {
                        margin: 0;
                        white-space: nowrap;
                    }

                    /* Đảm bảo cột Actions có đủ không gian */
                    .table th:last-child,
                    .table td:last-child {
                        min-width: 250px;
                        width: 250px;
                    }

                    .alert {
                        padding: 15px;
                        border-radius: 5px;
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

                    @media (max-width: 768px) {
                        .container {
                            padding: 10px;
                        }

                        .header {
                            flex-direction: column;
                            gap: 15px;
                            align-items: flex-start;
                        }

                        .search-form {
                            flex-direction: column;
                            align-items: stretch;
                        }

                        .table-container {
                            overflow-x: auto;
                        }

                        .table {
                            min-width: 600px;
                        }

                        .action-buttons {
                            flex-direction: column;
                        }
                    }

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
                                <a href="/admin" class="nav-item ">
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
                                <h3>Information</h3>
                                <a href="/auth/logout" class="nav-item">
                                    <i class="fa-solid fa-right-from-bracket"></i> Logout
                                </a>
                            </div>

                        </nav>
                    </div>
                    <!-- Main Content -->
                    <div class="admin-main">
                        <div class="container">
                            <!-- Header -->
                            <div class="header">
                                <div>
                                    <h1>User Management</h1>
                                    <p>Manage system users and their permissions</p>
                                </div>
                                <a href="/admin/users/add" class="btn btn-primary">
                                    <i class="fa-solid fa-plus"></i>
                                    Add New User
                                </a>
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

                            <!-- Search Section -->
                            <div class="search-section">
                                <form method="GET" action="/admin/users" class="search-form">
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
                                            <option value="ADMIN" ${param.role=='ADMIN' ? 'selected' : '' }>Admin
                                            </option>
                                            <option value="USER" ${param.role=='USER' ? 'selected' : '' }>User</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label for="status">Status</label>
                                        <select id="status" name="status" class="form-control">
                                            <option value="">All Status</option>
                                            <option value="active" ${param.status=='active' ? 'selected' : '' }>Active
                                            </option>
                                            <option value="inactive" ${param.status=='inactive' ? 'selected' : '' }>
                                                Inactive
                                            </option>
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

                            <!-- Debug Info -->
                            <div
                                style="background: #e3f2fd; padding: 15px; border-radius: 5px; margin-bottom: 20px; font-size: 14px;">
                                <strong>Debug Info:</strong><br>
                                Total users: ${users.size()}<br>
                                Users list:
                                <c:forEach var="user" items="${users}" varStatus="status">
                                    ${user.username}${!status.last ? ', ' : ''}
                                </c:forEach>
                            </div>

                            <!-- Users Table -->
                            <div class="table-container">
                                <div class="table-header">
                                    <h3>Users List (${users.size()} user${users.size() != 1 ? 's' : ''})</h3>
                                    <c:if
                                        test="${not empty param.search or not empty param.role or not empty param.status}">
                                        <span style="color: #7f8c8d; font-size: 14px;">
                                            <i class="fa-solid fa-filter"></i>
                                            Filtered results
                                        </span>
                                    </c:if>
                                </div>

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
                                                            <i class="fa-solid fa-users"
                                                                style="font-size: 48px; margin-bottom: 15px; display: block; opacity: 0.5;"></i>
                                                            <p>No users found</p>
                                                            <p style="font-size: 14px; margin-top: 10px;">Try adjusting
                                                                your
                                                                search criteria or add a new user.</p>
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
                                                                    <c:choose>
                                                                        <c:when test="${not empty user.fullName}">
                                                                            ${user.fullName.substring(0,
                                                                            1).toUpperCase()}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            ${user.username.substring(0,
                                                                            1).toUpperCase()}
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <div class="user-details">
                                                                    <h4>
                                                                        <c:choose>
                                                                            <c:when test="${not empty user.fullName}">
                                                                                ${user.fullName}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                N/A
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </h4>
                                                                    <p>@${user.username}</p>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>${user.email}</td>
                                                        <td>
                                                            <span class="badge badge-${user.role.name().toLowerCase()}">
                                                                ${user.role.name()}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <span
                                                                class="badge ${user.isActive() ? 'badge-active' : 'badge-inactive'}">
                                                                ${user.isActive() ? 'Active' : 'Inactive'}
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${user.createdAt != null}">
                                                                    ${user.createdAt}
                                                                </c:when>
                                                                <c:otherwise>
                                                                    N/A
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <div class="action-buttons">
                                                                <a href="/admin/users/view/${user.id}"
                                                                    class="btn btn-success btn-sm">
                                                                    <i class="fa-solid fa-eye"></i>
                                                                    View
                                                                </a>
                                                                <a href="/admin/users/edit/${user.id}"
                                                                    class="btn btn-warning btn-sm">
                                                                    <i class="fa-solid fa-edit"></i>
                                                                    Edit
                                                                </a>
                                                                <form method="POST"
                                                                    action="/admin/users/toggle-status/${user.id}"
                                                                    style="display: inline;"
                                                                    onsubmit="return confirm('Are you sure you want to ${user.isActive() ? 'deactivate' : 'activate'} this user?')">
                                                                    <button type="submit"
                                                                        class="btn ${user.isActive() ? 'btn-warning' : 'btn-success'} btn-sm">
                                                                        <i
                                                                            class="fa-solid ${user.isActive() ? 'fa-user-slash' : 'fa-user-check'}"></i>
                                                                        ${user.isActive() ? 'Deactivate' : 'Activate'}
                                                                    </button>
                                                                </form>
                                                                <form method="POST"
                                                                    action="/admin/users/delete/${user.id}"
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
                    document.addEventListener('DOMContentLoaded', function () {
                        // Auto-submit search form when pressing Enter
                        const searchInput = document.getElementById('search');
                        if (searchInput) {
                            searchInput.addEventListener('keypress', function (e) {
                                if (e.key === 'Enter') {
                                    e.preventDefault();
                                    this.closest('form').submit();
                                }
                            });
                        }

                        // Debug: Log user count
                        console.log('Total users found:', ${ users.size() });
                        console.log('Users in table:', document.querySelectorAll('tbody tr').length);

                        // Debug: Check if action buttons are visible
                        const actionButtons = document.querySelectorAll('.action-buttons');
                        console.log('Action button containers found:', actionButtons.length);
                        actionButtons.forEach((container, index) => {
                            console.log(`Action container ${index + 1}:`, container.innerHTML);
                        });

                        // Debug: Check table structure
                        const tableRows = document.querySelectorAll('tbody tr');
                        tableRows.forEach((row, index) => {
                            const cells = row.querySelectorAll('td');
                            console.log(`Row ${index + 1} has ${cells.length} cells`);
                            if (cells.length > 0) {
                                console.log(`Row ${index + 1} last cell:`, cells[cells.length - 1].innerHTML);
                            }
                        });
                    })

                    document.addEventListener('DOMContentLoaded', function () {
                        const sidebar = document.getElementById('adminSidebar');
                        const toggleBtn = document.getElementById('mobileMenuToggle');
                        const overlay = document.getElementById('mobileOverlay');

                        function openSidebar() {
                            sidebar.classList.add('mobile-open');
                            overlay.classList.add('active');
                        }
                        function closeSidebar() {
                            sidebar.classList.remove('mobile-open');
                            overlay.classList.remove('active');
                        }
                        toggleBtn.addEventListener('click', function () {
                            if (sidebar.classList.contains('mobile-open')) {
                                closeSidebar();
                            } else {
                                openSidebar();
                            }
                        });
                        overlay.addEventListener('click', closeSidebar);

                        // Đóng sidebar khi chọn menu (mobile)
                        document.querySelectorAll('.nav-item').forEach(item => {
                            item.addEventListener('click', function () {
                                if (window.innerWidth <= 768) closeSidebar();
                            });
                        });
                    });
                </script>
            </body>

            </html>