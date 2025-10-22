<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Task Management - B-Smart</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" />
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Segoe UI', sans-serif;
                    background: #f5f7fa;
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
                    margin-bottom: 20px;
                }

                .btn {
                    padding: 10px 20px;
                    border: none;
                    border-radius: 5px;
                    text-decoration: none;
                    cursor: pointer;
                }

                .btn-primary {
                    background: #3498db;
                    color: white;
                }

                .table {
                    width: 100%;
                    border-collapse: collapse;
                    background: white;
                    border-radius: 10px;
                }

                .table th,
                .table td {
                    padding: 12px;
                    text-align: left;
                    border-bottom: 1px solid #ddd;
                }

                .badge {
                    padding: 4px 8px;
                    border-radius: 12px;
                    font-size: 11px;
                }

                .badge-high {
                    background: #f8d7da;
                    color: #721c24;
                }

                .badge-medium {
                    background: #fff3cd;
                    color: #856404;
                }

                .badge-low {
                    background: #d1ecf1;
                    color: #0c5460;
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
                        <div class="header" style="
    display: flex;
    justify-content: space-between;
">
                            <h1>Task Management</h1>
                            <a href="/admin/tasks/add" class="btn btn-primary">Add New Task</a>
                        </div>
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Assigned To</th>
                                    <th>Priority</th>
                                    <th>Status</th>
                                    <th>Deadline</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="task" items="${tasks}">
                                    <tr>
                                        <td>${task.title}</td>
                                        <td>${task.user != null ? task.user.username : 'Unassigned'}</td>
                                        <td><span
                                                class="badge badge-${task.priority.name().toLowerCase()}">${task.priority.name()}</span>
                                        </td>
                                        <td>${task.status.name()}</td>
                                        <td>${task.deadline != null ? task.deadline : 'N/A'}</td>
                                        <td>
                                            <a href="/admin/tasks/view/${task.id}" class="btn btn-primary">View</a>
                                            <a href="/admin/tasks/edit/${task.id}" class="btn btn-primary">Edit</a>
                                            <a href="/admin/tasks/delete/${task.id}" class="btn btn-primary">Delete</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </body>

        </html>