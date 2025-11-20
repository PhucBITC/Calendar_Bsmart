<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <title>Add Task - B-Smart</title>
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

                /* Alerts */
                .alert {
                    padding: 15px 20px;
                    border-radius: 8px;
                    margin-bottom: 20px;
                    border-left: 4px solid;
                }

                .alert-danger {
                    background: #f8d7da;
                    color: #721c24;
                    border-left-color: #e74c3c;
                }

                /* Form */
                .form-container {
                    background: white;
                    padding: 30px;
                    border-radius: 15px;
                    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
                }

                .form-title {
                    color: #2c3e50;
                    font-size: 24px;
                    font-weight: 600;
                    margin-bottom: 25px;
                    display: flex;
                    align-items: center;
                    gap: 12px;
                }

                .form-title i {
                    color: #3498db;
                }

                .form-row {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                    gap: 25px;
                    margin-bottom: 25px;
                }

                .form-group {
                    display: flex;
                    flex-direction: column;
                }

                .form-group label {
                    margin-bottom: 8px;
                    color: #2c3e50;
                    font-weight: 600;
                    font-size: 14px;
                }

                .form-group label.required::after {
                    content: " *";
                    color: #e74c3c;
                }

                .form-control {
                    padding: 12px 15px;
                    border: 2px solid #e9ecef;
                    border-radius: 8px;
                    font-size: 14px;
                    transition: all 0.3s ease;
                    background: white;
                    width: 100%;
                }

                .form-control:focus {
                    outline: none;
                    border-color: #3498db;
                    box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
                }

                textarea.form-control {
                    resize: vertical;
                    min-height: 120px;
                }

                .form-actions {
                    display: flex;
                    gap: 15px;
                    justify-content: flex-end;
                    padding-top: 25px;
                    border-top: 1px solid #e9ecef;
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

                    .form-row {
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

                    .form-container {
                        padding: 25px;
                    }

                    .form-actions {
                        flex-direction: column;
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

                    .form-container {
                        padding: 20px;
                    }

                    .form-title {
                        font-size: 20px;
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
                        <h2>
                            <a class="logoCalendar" href="/schedule/add" style="text-decoration: none;">B-Smart</a>
                        </h2>
                        <p>System Management</p>
                    </div>

                    <nav class="sidebar-nav">
                        <div class="nav-section">
                            <h3>Main Management</h3>
                            <a href="/admin" class="nav-item">
                                <i>📊</i>Dashboard
                            </a>
                            <a href="/admin/users" class="nav-item">
                                <i>👥</i>User Management
                            </a>
                            <a href="/admin/tasks" class="nav-item active">
                                <i>📋</i>Task Management
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
                            <h1>Add New Task</h1>
                            <p>Create a new task and assign it to a user</p>
                        </div>
                        <div class="header-actions">
                            <a href="/admin/tasks" class="btn btn-secondary">
                                <i class="fa-solid fa-arrow-left"></i>
                                Back to Tasks
                            </a>
                        </div>
                    </div>

                    <!-- Alerts -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">
                            <i class="fa-solid fa-exclamation-triangle"></i>
                            ${error}
                        </div>
                    </c:if>

                    <!-- Form -->
                    <div class="form-container">
                        <h2 class="form-title">
                            <i class="fa-solid fa-clipboard-list"></i>
                            Task Details
                        </h2>

                        <form method="POST" action="/admin/tasks/add" id="addTaskForm">
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="title" class="required">Task Title</label>
                                    <input type="text" id="title" name="title" class="form-control" required
                                        placeholder="Enter task title">
                                </div>
                                <div class="form-group">
                                    <label for="user">Assign To</label>
                                    <select id="user" name="user.id" class="form-control">
                                        <option value="">Select User</option>
                                        <c:forEach var="user" items="${users}">
                                            <option value="${user.id}">${user.username} (${user.fullName != null ?
                                                user.fullName : 'N/A'})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group" style="margin-bottom: 25px;">
                                <label for="description">Description</label>
                                <textarea id="description" name="description" class="form-control"
                                    placeholder="Enter task description..."></textarea>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="priority" class="required">Priority</label>
                                    <select id="priority" name="priority" class="form-control" required>
                                        <option value="">Select Priority</option>
                                        <option value="HIGH">High</option>
                                        <option value="MEDIUM">Medium</option>
                                        <option value="LOW">Low</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="status" class="required">Status</label>
                                    <select id="status" name="status" class="form-control" required>
                                        <option value="">Select Status</option>
                                        <option value="PENDING">Pending</option>
                                        <option value="IN_PROGRESS">In Progress</option>
                                        <option value="COMPLETED">Completed</option>
                                    </select>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label for="deadline">Deadline</label>
                                    <input type="date" id="deadline" name="deadline" class="form-control">
                                </div>
                                <div class="form-group">
                                    <label for="estimatedDuration">Estimated Duration (minutes)</label>
                                    <input type="number" id="estimatedDuration" name="estimatedDuration"
                                        class="form-control" min="0">
                                </div>
                            </div>

                            <div class="form-actions">
                                <a href="/admin/tasks" class="btn btn-secondary">
                                    <i class="fa-solid fa-times"></i>
                                    Cancel
                                </a>
                                <button type="submit" class="btn btn-success">
                                    <i class="fa-solid fa-save"></i>
                                    Create Task
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <script>
                // Mobile menu functionality
                document.addEventListener('DOMContentLoaded', function () {
                    const mobileMenuToggle = document.getElementById('mobileMenuToggle');
                    const adminSidebar = document.getElementById('adminSidebar');
                    const mobileOverlay = document.getElementById('mobileOverlay');

                    function toggleMobileMenu() {
                        mobileMenuToggle.classList.toggle('active');
                        adminSidebar.classList.toggle('mobile-open');
                        mobileOverlay.classList.toggle('active');
                        document.body.style.overflow = adminSidebar.classList.contains('mobile-open') ? 'hidden' : '';
                    }

                    function closeMobileMenu() {
                        mobileMenuToggle.classList.remove('active');
                        adminSidebar.classList.remove('mobile-open');
                        mobileOverlay.classList.remove('active');
                        document.body.style.overflow = '';
                    }

                    mobileMenuToggle.addEventListener('click', toggleMobileMenu);
                    mobileOverlay.addEventListener('click', closeMobileMenu);

                    const navItems = document.querySelectorAll('.nav-item');
                    navItems.forEach(item => {
                        item.addEventListener('click', function () {
                            if (window.innerWidth <= 768) {
                                closeMobileMenu();
                            }
                        });
                    });

                    window.addEventListener('resize', function () {
                        if (window.innerWidth > 768) {
                            closeMobileMenu();
                        }
                    });
                });
            </script>
        </body>

        </html>