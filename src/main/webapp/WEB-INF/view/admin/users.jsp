<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý người dùng - BSmart Calendar</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f8fafc;
            color: #334155;
        }

        .header {
            background: white;
            padding: 1rem 2rem;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .header h1 {
            color: #2563eb;
            font-size: 1.5rem;
        }

        .header-nav {
            display: flex;
            gap: 1rem;
        }

        .nav-link {
            text-decoration: none;
            color: #64748b;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            transition: all 0.2s;
        }

        .nav-link:hover {
            background: #f1f5f9;
            color: #2563eb;
        }

        .nav-link.active {
            background: #2563eb;
            color: white;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .table-container {
            background: white;
            border-radius: 0.75rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .table-header {
            padding: 1.5rem;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: between;
            align-items: center;
        }

        .table-header h2 {
            color: #1e293b;
            font-size: 1.25rem;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 0.875rem;
        }

        .btn-primary {
            background: #2563eb;
            color: white;
        }

        .btn-primary:hover {
            background: #1d4ed8;
        }

        .btn-secondary {
            background: #64748b;
            color: white;
        }

        .btn-secondary:hover {
            background: #475569;
        }

        .btn-danger {
            background: #dc2626;
            color: white;
        }

        .btn-danger:hover {
            background: #b91c1c;
        }

        .btn-success {
            background: #16a34a;
            color: white;
        }

        .btn-success:hover {
            background: #15803d;
        }

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.75rem;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }

        th {
            background: #f8fafc;
            font-weight: 600;
            color: #64748b;
            font-size: 0.875rem;
        }

        td {
            color: #1e293b;
        }

        .user-avatar {
            width: 2.5rem;
            height: 2.5rem;
            border-radius: 50%;
            background: #2563eb;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 0.875rem;
        }

        .role-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.75rem;
            font-weight: 500;
        }

        .role-admin {
            background: #fef3c7;
            color: #92400e;
        }

        .role-user {
            background: #dbeafe;
            color: #1e40af;
        }

        .actions {
            display: flex;
            gap: 0.5rem;
        }

        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #64748b;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #cbd5e1;
        }

        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 1rem;
            }

            .header-nav {
                flex-wrap: wrap;
                justify-content: center;
            }

            .container {
                padding: 1rem;
            }

            .table-header {
                flex-direction: column;
                gap: 1rem;
                align-items: flex-start;
            }

            .actions {
                flex-direction: column;
            }

            table {
                font-size: 0.875rem;
            }

            th, td {
                padding: 0.75rem 0.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <h1><i class="fas fa-users"></i> Quản lý người dùng</h1>
        <div class="header-nav">
            <a href="/admin/dashboard" class="nav-link">Dashboard</a>
            <a href="/admin/users" class="nav-link active">Quản lý người dùng</a>
            <a href="/admin/schedules" class="nav-link">Quản lý lịch</a>
            <a href="/schedule/add" class="nav-link">Về lịch</a>
            <a href="/auth/logout" class="nav-link">Đăng xuất</a>
        </div>
    </div>

    <div class="container">
        <div class="table-container">
            <div class="table-header">
                <h2>Danh sách người dùng (${users.size()})</h2>
                <button class="btn btn-primary" onclick="refreshUsers()">
                    <i class="fas fa-sync"></i> Làm mới
                </button>
            </div>

            <c:choose>
                <c:when test="${empty users}">
                    <div class="empty-state">
                        <i class="fas fa-users"></i>
                        <h3>Chưa có người dùng nào</h3>
                        <p>Hệ thống chưa có người dùng nào được đăng ký.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>Người dùng</th>
                                <th>Email</th>
                                <th>Vai trò</th>
                                <th>Ngày tạo</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td>
                                        <div style="display: flex; align-items: center; gap: 1rem;">
                                            <div class="user-avatar">
                                                ${user.username.charAt(0).toUpperCase()}
                                            </div>
                                            <div>
                                                <div style="font-weight: 500;">${user.username}</div>
                                                <div style="font-size: 0.875rem; color: #64748b;">
                                                    ${user.fullName != null ? user.fullName : 'Chưa cập nhật'}
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>${user.email}</td>
                                    <td>
                                        <span class="role-badge ${user.role.value == 'ADMIN' ? 'role-admin' : 'role-user'}">
                                            ${user.role.value}
                                        </span>
                                    </td>
                                    <td>
                                        <c:if test="${user.createdAt != null}">
                                            ${user.createdAt}
                                        </c:if>
                                        <c:if test="${user.createdAt == null}">
                                            <span style="color: #64748b;">Chưa có</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <button class="btn btn-sm ${user.role.value == 'ADMIN' ? 'btn-secondary' : 'btn-success'}" 
                                                    onclick="toggleRole(${user.id})"> 
                                                <i class="fas ${user.role.value == 'ADMIN' ? 'fa-user' : 'fa-user-shield'}"></i>
                                                ${user.role.value == 'ADMIN' ? 'Hạ quyền' : 'Thăng quyền'}
                                            </button>
                                            <button class="btn btn-sm btn-danger" onclick="deleteUser(${user.id}, '${user.username}')">
                                                <i class="fas fa-trash"></i> Xóa
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        function toggleRole(userId) {
            if (confirm('Bạn có chắc muốn thay đổi vai trò của người dùng này?')) {
                fetch(`/admin/users/${userId}/toggle-role`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showNotification('Cập nhật vai trò thành công!', 'success');
                        setTimeout(() => {
                            location.reload();
                        }, 1000);
                    } else {
                        showNotification('Lỗi: ' + data.message, 'error');
                    }
                })
                .catch(error => {
                    showNotification('Lỗi kết nối mạng', 'error');
                });
            }
        }

        function deleteUser(userId, username) {
            if (confirm(`Bạn có chắc muốn xóa người dùng "${username}"? Hành động này không thể hoàn tác.`)) {
                fetch(`/admin/users/${userId}`, {
                    method: 'DELETE'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showNotification('Xóa người dùng thành công!', 'success');
                        setTimeout(() => {
                            location.reload();
                        }, 1000);
                    } else {
                        showNotification('Lỗi: ' + data.message, 'error');
                    }
                })
                .catch(error => {
                    showNotification('Lỗi kết nối mạng', 'error');
                });
            }
        }

        function refreshUsers() {
            location.reload();
        }

        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 1rem 1.5rem;
                border-radius: 0.5rem;
                color: white;
                font-weight: 500;
                z-index: 1000;
                animation: slideIn 0.3s ease;
            `;
            
            if (type === 'success') {
                notification.style.background = '#16a34a';
            } else {
                notification.style.background = '#dc2626';
            }
            
            notification.textContent = message;
            document.body.appendChild(notification);
            
            setTimeout(() => {
                notification.remove();
            }, 3000);
        }
    </script>
</body>
</html>
