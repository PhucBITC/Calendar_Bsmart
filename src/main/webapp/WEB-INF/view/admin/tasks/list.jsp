<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

            <!DOCTYPE html>
            <html>

            <head>
                <title>Task Management - B-Smart</title>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <!-- Bootstrap 5 CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
                    integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
                    crossorigin="anonymous">
                <!-- Font Awesome -->
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css" />
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
                                <a href="/admin/users" class="nav-link">
                                    <i>👥</i>User Management
                                </a>
                                <a href="/admin/tasks" class="nav-link active">
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
                                <h1 class="h2">Task Management</h1>
                                <p class="text-muted">Manage all system tasks.</p>
                            </div>
                            <a href="/admin/tasks/add" class="btn btn-primary">
                                <i class="fa-solid fa-plus"></i> Add New Task
                            </a>
                        </div>

                        <!-- Search & Filter Section -->
                        <div class="card shadow-sm mb-4">
                            <div class="card-body">
                                <form method="GET" action="/admin/tasks">
                                    <div class="row g-3 align-items-end">
                                        <div class="col-md-4">
                                            <label for="search" class="form-label">Search Tasks</label>
                                            <input type="text" id="search" name="search" class="form-control"
                                                placeholder="Title, description, user..." value="${param.search}">
                                        </div>
                                        <div class="col-md-3">
                                            <label for="priority" class="form-label">Priority</label>
                                            <select id="priority" name="priority" class="form-select">
                                                <option value="">All Priorities</option>
                                                <option value="HIGH" <c:if test="${param.priority == 'HIGH'}">selected
                                                    </c:if>>High</option>
                                                <option value="MEDIUM" <c:if test="${param.priority == 'MEDIUM'}">
                                                    selected</c:if>>Medium</option>
                                                <option value="LOW" <c:if test="${param.priority == 'LOW'}">selected
                                                    </c:if>>Low</option>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <label for="status" class="form-label">Status</label>
                                            <select id="status" name="status" class="form-select">
                                                <option value="">All Statuses</option>
                                                <option value="PENDING" <c:if test="${param.status == 'PENDING'}">
                                                    selected</c:if>>Pending</option>
                                                <option value="IN_PROGRESS" <c:if
                                                    test="${param.status == 'IN_PROGRESS'}">selected</c:if>>In Progress
                                                </option>
                                                <option value="COMPLETED" <c:if test="${param.status == 'COMPLETED'}">
                                                    selected</c:if>>Completed</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2 d-flex gap-2">
                                            <button type="submit" class="btn btn-primary w-100"><i
                                                    class="fa-solid fa-search"></i></button>
                                            <a href="/admin/tasks" class="btn btn-secondary w-100"><i
                                                    class="fa-solid fa-times"></i></a>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Tasks Table -->
                        <div class="card shadow-sm">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">Tasks List (${tasks.size()} task${tasks.size() != 1 ? 's' : ''})</h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover table-striped mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th scope="col">Title</th>
                                                <th scope="col">Assigned To</th>
                                                <th scope="col">Priority</th>
                                                <th scope="col">Status</th>
                                                <th scope="col">Deadline</th>
                                                <th scope="col" class="text-end">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:choose>
                                                <c:when test="${empty tasks}">
                                                    <tr>
                                                        <td colspan="6" class="text-center py-5">
                                                            <div class="text-muted">
                                                                <i class="fa-solid fa-tasks fa-3x mb-3"></i>
                                                                <p class="mb-0">No tasks found.</p>
                                                                <small>Try adjusting your search criteria or add a new
                                                                    task.</small>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:forEach var="task" items="${tasks}">
                                                        <tr>
                                                            <td class="align-middle">${task.title}</td>
                                                            <td class="align-middle">${task.user != null ?
                                                                task.user.username : 'Unassigned'}</td>
                                                            <td class="align-middle">
                                                                <c:set var="priorityClass" value="" />
                                                                <c:if test="${task.priority.name() == 'HIGH'}">
                                                                    <c:set var="priorityClass" value="text-bg-danger" />
                                                                </c:if>
                                                                <c:if test="${task.priority.name() == 'MEDIUM'}">
                                                                    <c:set var="priorityClass"
                                                                        value="text-bg-warning" />
                                                                </c:if>
                                                                <c:if test="${task.priority.name() == 'LOW'}">
                                                                    <c:set var="priorityClass" value="text-bg-info" />
                                                                </c:if>
                                                                <span
                                                                    class="badge ${priorityClass}">${task.priority.name()}</span>
                                                            </td>
                                                            <td class="align-middle">
                                                                <c:set var="statusClass" value="text-bg-secondary" />
                                                                <c:if test="${task.status.name() == 'PENDING'}">
                                                                    <c:set var="statusClass"
                                                                        value="text-bg-secondary" />
                                                                </c:if>
                                                                <c:if test="${task.status.name() == 'IN_PROGRESS'}">
                                                                    <c:set var="statusClass" value="text-bg-primary" />
                                                                </c:if>
                                                                <c:if test="${task.status.name() == 'COMPLETED'}">
                                                                    <c:set var="statusClass" value="text-bg-success" />
                                                                </c:if>
                                                                <span
                                                                    class="badge ${statusClass}">${task.status.name().replace('_',
                                                                    ' ')}</span>
                                                            </td>
                                                            <td class="align-middle">
                                                                <c:choose>
                                                                    <c:when test="${task.deadline != null}">
                                                                        <fmt:parseDate value="${task.deadline}"
                                                                            pattern="yyyy-MM-dd" var="parsedDate"
                                                                            type="date" />
                                                                        <fmt:formatDate value="${parsedDate}"
                                                                            pattern="dd/MM/yyyy" />
                                                                    </c:when>
                                                                    <c:otherwise>N/A</c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td class="align-middle text-end">
                                                                <div class="btn-group btn-group-sm" role="group">
                                                                    <a href="/admin/tasks/view/${task.id}"
                                                                        class="btn btn-outline-success" title="View"><i
                                                                            class="fa-solid fa-eye"></i></a>
                                                                    <a href="/admin/tasks/edit/${task.id}"
                                                                        class="btn btn-outline-warning" title="Edit"><i
                                                                            class="fa-solid fa-edit"></i></a>
                                                                    <form method="POST"
                                                                        action="/admin/tasks/delete/${task.id}"
                                                                        class="d-inline"
                                                                        onsubmit="return confirm('Are you sure you want to delete this task?')">
                                                                        <button type="submit"
                                                                            class="btn btn-outline-danger"
                                                                            title="Delete"><i
                                                                                class="fa-solid fa-trash"></i></button>
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
                </main>
                </main>

                <!-- Bootstrap 5 JS -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
                    integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
                    crossorigin="anonymous"></script>
            </body>

            </html>