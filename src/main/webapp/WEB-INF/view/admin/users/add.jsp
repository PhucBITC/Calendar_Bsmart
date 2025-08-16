<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <title>Add New User - B-Smart</title>
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
        }

        .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        .form-control.error {
            border-color: #e74c3c;
            box-shadow: 0 0 0 3px rgba(231, 76, 60, 0.1);
        }

        .form-control.success {
            border-color: #27ae60;
            box-shadow: 0 0 0 3px rgba(39, 174, 96, 0.1);
        }

        .error-message {
            color: #e74c3c;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        .error-message.show {
            display: block;
        }

        .form-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            padding-top: 25px;
            border-top: 1px solid #e9ecef;
        }

        .password-toggle {
            position: relative;
        }

        .password-toggle .form-control {
            padding-right: 45px;
        }

        .password-toggle-btn {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #7f8c8d;
            cursor: pointer;
            padding: 5px;
            transition: color 0.3s ease;
        }

        .password-toggle-btn:hover {
            color: #3498db;
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
                    <h1>Add New User</h1>
                    <p>Create a new user account in the system</p>
                </div>
                <div class="header-actions">
                    <a href="/admin/users" class="btn btn-secondary">
                        <i class="fa-solid fa-arrow-left"></i>
                        Back to Users
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
                    <i class="fa-solid fa-user-plus"></i>
                    User Information
                </h2>

                <form method="POST" action="/admin/users/add" id="addUserForm">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="username" class="required">Username</label>
                            <input type="text" id="username" name="username" class="form-control" 
                                   value="${user.username}" required minlength="3" maxlength="50"
                                   placeholder="Enter username">
                            <div class="error-message" id="username-error"></div>
                        </div>

                        <div class="form-group">
                            <label for="email" class="required">Email</label>
                            <input type="email" id="email" name="email" class="form-control" 
                                   value="${user.email}" required
                                   placeholder="Enter email address">
                            <div class="error-message" id="email-error"></div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="password" class="required">Password</label>
                            <div class="password-toggle">
                                <input type="password" id="password" name="password" class="form-control" 
                                       required minlength="6"
                                       placeholder="Enter password">
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('password')">
                                    <i class="fa-solid fa-eye" id="password-icon"></i>
                                </button>
                            </div>
                            <div class="error-message" id="password-error"></div>
                        </div>

                        <div class="form-group">
                            <label for="confirmPassword" class="required">Confirm Password</label>
                            <div class="password-toggle">
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                                       required
                                       placeholder="Confirm password">
                                <button type="button" class="password-toggle-btn" onclick="togglePassword('confirmPassword')">
                                    <i class="fa-solid fa-eye" id="confirmPassword-icon"></i>
                                </button>
                            </div>
                            <div class="error-message" id="confirmPassword-error"></div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="fullName">Full Name</label>
                            <input type="text" id="fullName" name="fullName" class="form-control" 
                                   value="${user.fullName}"
                                   placeholder="Enter full name">
                        </div>

                        <div class="form-group">
                            <label for="phoneNumber">Phone Number</label>
                            <input type="tel" id="phoneNumber" name="phoneNumber" class="form-control" 
                                   value="${user.phoneNumber}"
                                   placeholder="Enter phone number">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="role" class="required">Role</label>
                            <select id="role" name="role" class="form-control" required>
                                <option value="">Select role</option>
                                <c:forEach var="role" items="${roles}">
                                    <option value="${role}" ${user.role == role ? 'selected' : ''}>
                                        ${role.name()}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="error-message" id="role-error"></div>
                        </div>

                        <div class="form-group">
                            <label for="isActive">Status</label>
                            <select id="isActive" name="isActive" class="form-control">
                                <option value="true" ${user.isActive() ? 'selected' : ''}>Active</option>
                                <option value="false" ${!user.isActive() ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-actions">
                        <a href="/admin/users" class="btn btn-secondary">
                            <i class="fa-solid fa-times"></i>
                            Cancel
                        </a>
                        <button type="submit" class="btn btn-success">
                            <i class="fa-solid fa-save"></i>
                            Create User
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

            // Form validation
            const form = document.getElementById('addUserForm');
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirmPassword');

            // Password toggle function
            window.togglePassword = function(fieldId) {
                const field = document.getElementById(fieldId);
                const icon = document.getElementById(fieldId + '-icon');
                
                if (field.type === 'password') {
                    field.type = 'text';
                    icon.classList.remove('fa-eye');
                    icon.classList.add('fa-eye-slash');
                } else {
                    field.type = 'password';
                    icon.classList.remove('fa-eye-slash');
                    icon.classList.add('fa-eye');
                }
            };

            // Password confirmation validation
            confirmPassword.addEventListener('input', function() {
                if (password.value !== confirmPassword.value) {
                    confirmPassword.classList.add('error');
                    confirmPassword.classList.remove('success');
                    document.getElementById('confirmPassword-error').textContent = 'Passwords do not match';
                    document.getElementById('confirmPassword-error').classList.add('show');
                } else {
                    confirmPassword.classList.remove('error');
                    confirmPassword.classList.add('success');
                    document.getElementById('confirmPassword-error').classList.remove('show');
                }
            });

            // Form submission validation
            form.addEventListener('submit', function(e) {
                let isValid = true;

                // Clear previous errors
                document.querySelectorAll('.error-message').forEach(error => {
                    error.classList.remove('show');
                });
                document.querySelectorAll('.form-control').forEach(input => {
                    input.classList.remove('error');
                });

                // Validate required fields
                const requiredFields = ['username', 'email', 'password', 'confirmPassword', 'role'];
                requiredFields.forEach(fieldId => {
                    const field = document.getElementById(fieldId);
                    if (!field.value.trim()) {
                        field.classList.add('error');
                        document.getElementById(fieldId + '-error').textContent = 'This field is required';
                        document.getElementById(fieldId + '-error').classList.add('show');
                        isValid = false;
                    }
                });

                // Validate email format
                const email = document.getElementById('email');
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                if (email.value && !emailRegex.test(email.value)) {
                    email.classList.add('error');
                    document.getElementById('email-error').textContent = 'Please enter a valid email address';
                    document.getElementById('email-error').classList.add('show');
                    isValid = false;
                }

                // Validate password length
                if (password.value && password.value.length < 6) {
                    password.classList.add('error');
                    document.getElementById('password-error').textContent = 'Password must be at least 6 characters';
                    document.getElementById('password-error').classList.add('show');
                    isValid = false;
                }

                // Validate password confirmation
                if (password.value !== confirmPassword.value) {
                    confirmPassword.classList.add('error');
                    document.getElementById('confirmPassword-error').textContent = 'Passwords do not match';
                    document.getElementById('confirmPassword-error').classList.add('show');
                    isValid = false;
                }

                if (!isValid) {
                    e.preventDefault();
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
