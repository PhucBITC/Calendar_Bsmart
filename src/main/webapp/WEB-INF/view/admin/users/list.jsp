<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>User Management - B-Smart</title>
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

                    .user-avatar {
                        width: 40px;
                        height: 40px;
                        border-radius: 50%;
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        font-weight: 600;
                        font-size: 1rem;
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
                            <a href="/schedule/add">B-Smart</a>
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
                                <a href="/admin" class="nav-link">
                                    <i>📊</i>Dashboard
                                </a>
                                <a href="/admin/users" class="nav-link active">
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
                        <div
                            class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-4 border-bottom">
                            <div>
                                <h1 class="h2">User Management</h1>
                                <p class="text-muted">Manage system users and their permissions.</p>
                            </div>
                            <a href="/admin/users/add" class="btn btn-primary">
                                <i class="fa-solid fa-plus"></i>
                                Add New User
                            </a>
                        </div>

                        <!-- Alerts -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fa-solid fa-check-circle"></i>
                                ${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fa-solid fa-exclamation-triangle"></i>
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"
                                    aria-label="Close"></button>
                            </div>
                        </c:if>

                        <!-- Search Section  -->
                        <div class="card shadow-sm mb-4">
                            <div class="card-body">
                                <form method="GET" action="/admin/users">
                                    <div class="row g-3 align-items-end">
                                        <div class="col-md-4">
                                            <label for="search" class="form-label">Search Users</label>
                                            <input type="text" id="search" name="search" class="form-control"
                                                placeholder="Username, email, name..." value="${param.search}">
                                        </div>
                                        <div class="col-md-3">
                                            <label for="role" class="form-label">Role</label>
                                            <select id="role" name="role" class="form-select">
                                                <option value="">All Roles</option>
                                                <option value="ADMIN" <c:if test="${param.role == 'ADMIN'}">selected
                                                    </c:if>>Admin</option>
                                                <option value="USER" <c:if test="${param.role == 'USER'}">selected
                                                    </c:if>>User</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label for="status" class="form-label">Status</label>
                                            <select id="status" name="status" class="form-select">
                                                <option value="">All Status</option>
                                                <option value="active" <c:if test="${param.status == 'active'}">selected
                                                    </c:if>>Active</option>
                                                <option value="inactive" <c:if test="${param.status == 'inactive'}">
                                                    selected</c:if>>Inactive</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2 d-flex gap-2">
                                            <button type="submit" class="btn btn-primary w-100">
                                                <i class="fa-solid fa-search"></i>
                                            </button>
                                            <a href="/admin/users" class="btn btn-secondary w-100">
                                                <i class="fa-solid fa-times"></i>
                                            </a>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>


                        <!-- Users Table -->
                        <div class="card shadow-sm">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Users List (${users.size()}
                                    user${users.size() != 1 ? 's' : ''})</h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover table-striped mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th scope="col">User</th>
                                                <th scope="col">Email</th>
                                                <th scope="col">Role</th>
                                                <th scope="col">Status</th>
                                                <th scope="col">Created</th>
                                                <th scope="col" class="text-end">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${empty users}">
                                                    <tr>
                                                        <td colspan="6" class="text-center py-5">
                                                            <div class="text-muted">
                                                                <i class="fa-solid fa-users fa-3x mb-3"></i>
                                                                <p class="mb-0">No users found.</p>
                                                                <small>Try adjusting your search criteria.</small>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="user" items="${users}">
                                                        <tr>
                                                            <td>
                                                                <div class="d-flex align-items-center">
                                                                    <div class="user-avatar bg-primary text-white me-3">
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
                                                                    <div>
                                                                        <div class="fw-bold">
                                                                            <c:choose>
                                                                                <c:when
                                                                                    test="${not empty user.fullName}">
                                                                                    ${user.fullName}
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    N/A
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                        <div class="text-muted small">
                                                                            @${user.username}</div>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <td class="align-middle">${user.email}</td>
                                                            <td class="align-middle">
                                                                <span
                                                                    class="badge ${user.role.name() == 'ADMIN' ? 'text-bg-warning' : 'text-bg-info'}">
                                                                    ${user.role.name()}
                                                                </span>
                                                            </td>
                                                            <td class="align-middle">
                                                                <span
                                                                    class="badge ${user.isActive() ? 'text-bg-success' : 'text-bg-secondary'}">
                                                                    ${user.isActive() ? 'Active' : 'Inactive'}
                                                                </span>
                                                            </td>
                                                            <td class="align-middle">
                                                                <c:choose>
                                                                    <c:when test="${user.createdAt != null}">
                                                                        <fmt:parseDate value="${user.createdAt}"
                                                                            pattern="yyyy-MM-dd'T'HH:mm:ss"
                                                                            var="parsedDate" type="both" />
                                                                        <fmt:formatDate value="${parsedDate}"
                                                                            pattern="dd/MM/yyyy" />
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        N/A
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="align-middle text-end">
                                                                <div class="btn-group btn-group-sm" role="group">
                                                                    <a href="/admin/users/view/${user.id}"
                                                                        class="btn btn-outline-success" title="View">
                                                                        <i class="fa-solid fa-eye"></i>
                                                                    </a>
                                                                    <a href="/admin/users/edit/${user.id}"
                                                                        class="btn btn-outline-warning" title="Edit">
                                                                        <i class="fa-solid fa-edit"></i>
                                                                    </a>
                                                                    <form method="POST"
                                                                        action="/admin/users/delete/${user.id}"
                                                                        class="d-inline"
                                                                        onsubmit="return confirm('Are you sure you want to delete this user? This action cannot be undone.')">
                                                                        <button type="submit"
                                                                            class="btn btn-outline-danger"
                                                                            title="Delete">
                                                                            <i class="fa-solid fa-trash"></i>
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
                </main>

                <!-- Bootstrap 5 JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
                    integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
                    crossorigin="anonymous"></script>

                <script>
                    document.addEventListener('DOMContentLoaded', function () {
                        // Kích hoạt tooltip của Bootstrap (nếu bạn muốn dùng)
                        const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
                        const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));
                    });
                </script>
            </body>

            </html>