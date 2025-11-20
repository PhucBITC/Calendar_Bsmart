<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>System Management - B-Smart</title>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <!-- Bootstrap 5 CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
                    integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
                    crossorigin="anonymous">
                <!-- Font Awesome -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css"
                    integrity="sha512-DxV+EoADOkOygM4IR9yXP8Sb2qwgidEmeqAEmDKIOfPRQZOWbXCzLC6vjbZyy0vPisbH2SyW27+ddLVCN+OMzQ=="
                    crossorigin="anonymous" referrerpolicy="no-referrer" />
                <style>
                    body {
                        background-color: #f0f2f5;
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    }

                    .sidebar {
                        height: 100vh;
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 280px;
                        background-color: #fff;
                        box-shadow: 2px 0 15px rgba(0, 0, 0, 0.1);
                        transition: all 0.3s ease;
                        z-index: 1045;
                    }

                    .main-content {
                        margin-left: 280px;
                        transition: all 0.3s ease;
                        padding: 2rem;
                        width: calc(100% - 280px);
                    }

                    .sidebar-header {
                        padding: 1.5rem;
                        text-align: center;
                        border-bottom: 1px solid #e9ecef;
                    }

                    .sidebar-header h2 a {
                        color: #2c3e50;
                        font-weight: 700;
                        text-decoration: none;
                    }

                    .sidebar-nav .nav-link {
                        color: #34495e;
                        padding: 0.8rem 1.5rem;
                        display: flex;
                        align-items: center;
                        border-left: 3px solid transparent;
                        transition: all 0.2s ease;
                    }

                    .sidebar-nav .nav-link:hover {
                        background-color: #f8f9fa;
                        color: #3498db;
                        border-left-color: #3498db;
                    }

                    .sidebar-nav .nav-link.active {
                        background-color: #e9ecef;
                        color: #3498db;
                        border-left-color: #3498db;
                        font-weight: 600;
                    }

                    .sidebar-nav .nav-link i {
                        width: 25px;
                        text-align: center;
                        margin-right: 0.5rem;
                    }

                    .nav-section-title {
                        color: #95a5a6;
                        font-size: 0.75rem;
                        text-transform: uppercase;
                        letter-spacing: 1px;
                        padding: 1.5rem 1.5rem 0.5rem;
                        font-weight: 600;
                    }

                    .mobile-menu-button {
                        display: none;
                        position: fixed;
                        top: 15px;
                        left: 15px;
                        z-index: 1041;
                    }

                    @media (max-width: 991.98px) {
                        .sidebar {
                            left: -280px;
                        }

                        .main-content {
                            margin-left: 0;
                            width: 100%;
                        }

                        .mobile-menu-button {
                            display: block;
                        }
                    }

                    .stat-card .stat-icon {
                        font-size: 1.75rem;
                        width: 60px;
                        height: 60px;
                    }

                    .stat-card.border-left-primary {
                        border-left: 0.25rem solid #4e73df !important;
                    }

                    .stat-card.border-left-success {
                        border-left: 0.25rem solid #1cc88a !important;
                    }

                    .stat-card.border-left-info {
                        border-left: 0.25rem solid #36b9cc !important;
                    }

                    .stat-card.border-left-warning {
                        border-left: 0.25rem solid #f6c23e !important;
                    }

                    .action-btn {
                        transition: all 0.2s ease-in-out;
                    }

                    .action-btn:hover {
                        transform: translateY(-3px);
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                    }

                    .logoCalendar:hover {
                        color: rgb(54, 11, 51);
                    }
                </style>
            </head>

            <body>
                <!-- Mobile Menu Button -->
                <button class="btn btn-primary mobile-menu-button" type="button" data-bs-toggle="offcanvas"
                    data-bs-target="#adminSidebar" aria-controls="adminSidebar">
                    <i class="fa-solid fa-bars"></i>
                </button>

                <!-- Sidebar (Offcanvas for mobile) -->
                <div class="offcanvas-lg offcanvas-start sidebar" tabindex="-1" id="adminSidebar"
                    aria-labelledby="adminSidebarLabel">
                    <div class="offcanvas-header sidebar-header">
                        <h2 class="offcanvas-title" id="adminSidebarLabel">
                            <a class="logoCalendar" href="/schedule/add">B-Smart</a>
                        </h2>
                        <button type="button" class="btn-close" data-bs-dismiss="offcanvas"
                            data-bs-target="#adminSidebar" aria-label="Close"></button>
                    </div>
                    <div class="offcanvas-body d-flex flex-column p-0">
                        <nav class="sidebar-nav flex-grow-1">
                            <div class="sidebar-header">
                                <h2>
                                    <a class="logoCalendar" href="/schedule/add"
                                        style="text-decoration: none;">B-Smart</a>
                                </h2>
                                <p>System Management</p>
                            </div>
                            <div>
                                <h3 class="nav-section-title">Main Management</h3>
                                <a href="/admin" class="nav-link active">
                                    <i>📊</i>Dashboard
                                </a>
                                <a href="/admin/users" class="nav-link">
                                    <i>👥</i>User Management
                                </a>
                                <a href="/admin/tasks" class="nav-link">
                                    <i>📋</i>Task Management
                                </a>
                            </div>
                            <div>
                                <h3 class="nav-section-title">Reports</h3>
                                <a href="/admin/reports" class="nav-link">
                                    <i>📈</i>Statistics Report
                                </a>
                                <a href="/admin/analytics" class="nav-link">
                                    <i>📊</i>Data Analytics
                                </a>
                            </div>
                            <div>
                                <h3 class="nav-section-title">System</h3>
                                <a href="/admin/settings" class="nav-link">
                                    <i>⚙️</i>Settings
                                </a>
                                <a href="/admin/logs" class="nav-link">
                                    <i>📝</i>System Logs
                                </a>
                            </div>
                            <div>
                                <a href="/auth/logout" class="nav-link">
                                    <i class="fa-solid fa-right-from-bracket"></i> Logout
                                </a>
                            </div>
                        </nav>

                    </div>
                </div>

                <!-- Main Content -->
                <main class="main-content">
                    <div class="container-fluid">
                        <!-- Header -->
                        <div class="d-flex justify-content-between align-items-center pt-3 pb-2 mb-4 border-bottom">
                            <div>
                                <h1 class="h2">Dashboard</h1>
                                <p class="text-muted">Welcome to the B-Smart management system.</p>
                            </div>
                        </div>

                        <!-- Stats Cards -->
                        <div class="row g-4 mb-4">
                            <!-- Total Users Card -->
                            <div class="col-md-6 col-xl-3">
                                <div class="card stat-card border-left-primary shadow-sm h-100">
                                    <div class="card-body">
                                        <div class="row no-gutters align-items-center">
                                            <div class="col me-2">
                                                <div class="text-xs fw-bold text-primary text-uppercase mb-1">Total
                                                    Users</div>
                                                <div class="h5 mb-0 fw-bold text-gray-800">${totalUsers}</div>
                                            </div>
                                            <div class="col-auto">
                                                <i class="fas fa-users fa-2x text-gray-300"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Ongoing Tasks Card -->
                            <div class="col-md-6 col-xl-3">
                                <div class="card stat-card border-left-success shadow-sm h-100">
                                    <div class="card-body">
                                        <div class="row no-gutters align-items-center">
                                            <div class="col me-2">
                                                <div class="text-xs fw-bold text-success text-uppercase mb-1">Total
                                                    Tasks</div>
                                                <div class="h5 mb-0 fw-bold text-gray-800">${totalTasks}</div>
                                            </div>
                                            <div class="col-auto">
                                                <i class="fas fa-clipboard-list fa-2x text-gray-300"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Schedules Created Card -->
                            <div class="col-md-6 col-xl-3">
                                <div class="card stat-card border-left-info shadow-sm h-100">
                                    <div class="card-body">
                                        <div class="row no-gutters align-items-center">
                                            <div class="col me-2">
                                                <div class="text-xs fw-bold text-info text-uppercase mb-1">Schedules
                                                    Created</div>
                                                <div class="h5 mb-0 fw-bold text-gray-800">${totalSchedules}</div>
                                            </div>
                                            <div class="col-auto">
                                                <i class="fas fa-calendar-alt fa-2x text-gray-300"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- System Performance Card -->
                            <div class="col-md-6 col-xl-3">
                                <div class="card stat-card border-left-warning shadow-sm h-100">
                                    <div class="card-body">
                                        <div class="row no-gutters align-items-center">
                                            <div class="col me-2">
                                                <div class="text-xs fw-bold text-warning text-uppercase mb-1">System
                                                    Performance</div>
                                                <div class="h5 mb-0 fw-bold text-gray-800">${systemPerformance}%</div>
                                            </div>
                                            <div class="col-auto">
                                                <i class="fas fa-bolt fa-2x text-gray-300"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Actions -->
                        <div class="card shadow-sm">
                            <div class="card-header">
                                <h5 class="mb-0"><i class="fas fa-bolt me-2"></i>Quick Actions</h5>
                            </div>
                            <div class="card-body">
                                <div class="row g-3">
                                    <div class="col-sm-6 col-lg-4">
                                        <a href="/admin/users/add"
                                            class="d-block btn btn-light border p-3 text-start action-btn">
                                            <h6 class="mb-1"><i class="fas fa-user-plus me-2 text-primary"></i>Add New
                                                User</h6>
                                            <small class="text-muted">Quickly create a new user account.</small>
                                        </a>
                                    </div>
                                    <div class="col-sm-6 col-lg-4">
                                        <a href="/admin/tasks/add"
                                            class="d-block btn btn-light border p-3 text-start action-btn">
                                            <h6 class="mb-1"><i class="fas fa-tasks me-2 text-success"></i>Create New
                                                Task</h6>
                                            <small class="text-muted">Assign a new task to a user.</small>
                                        </a>
                                    </div>
                                    <div class="col-sm-6 col-lg-4">
                                        <a href="/schedule/add"
                                            class="d-block btn btn-light border p-3 text-start action-btn">
                                            <h6 class="mb-1"><i class="fas fa-calendar-plus me-2 text-info"></i>Create
                                                New Schedule</h6>
                                            <small class="text-muted">Go to the main scheduling page.</small>
                                        </a>
                                    </div>
                                    <div class="col-sm-6 col-lg-4">
                                        <a href="/admin/reports"
                                            class="d-block btn btn-light border p-3 text-start action-btn">
                                            <h6 class="mb-1"><i class="fas fa-chart-line me-2 text-warning"></i>View
                                                Reports</h6>
                                            <small class="text-muted">Analyze system usage and statistics.</small>
                                        </a>
                                    </div>
                                    <div class="col-sm-6 col-lg-4">
                                        <a href="/admin/settings"
                                            class="d-block btn btn-light border p-3 text-start action-btn">
                                            <h6 class="mb-1"><i class="fas fa-cog me-2 text-secondary"></i>System
                                                Settings</h6>
                                            <small class="text-muted">Configure system parameters.</small>
                                        </a>
                                    </div>
                                    <div class="col-sm-6 col-lg-4">
                                        <a href="/admin/backup"
                                            class="d-block btn btn-light border p-3 text-start action-btn">
                                            <h6 class="mb-1"><i class="fas fa-save me-2 text-danger"></i>Backup Data
                                            </h6>
                                            <small class="text-muted">Create a backup of the database.</small>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>

                <!-- Bootstrap 5 JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
                    integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
                    crossorigin="anonymous"></script>
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