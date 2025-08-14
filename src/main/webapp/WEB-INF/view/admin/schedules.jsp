<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý lịch - BSmart Calendar</title>
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

        .schedule-color {
            width: 1rem;
            height: 1rem;
            border-radius: 50%;
            display: inline-block;
            margin-right: 0.5rem;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .user-avatar {
            width: 2rem;
            height: 2rem;
            border-radius: 50%;
            background: #2563eb;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 0.75rem;
        }

        .time-info {
            font-size: 0.875rem;
            color: #64748b;
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

        .filter-section {
            background: white;
            padding: 1.5rem;
            border-radius: 0.75rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
        }

        .filter-row {
            display: flex;
            gap: 1rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .filter-group label {
            font-size: 0.875rem;
            font-weight: 500;
            color: #64748b;
        }

        .filter-group input, .filter-group select {
            padding: 0.5rem;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            font-size: 0.875rem;
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

            .filter-row {
                flex-direction: column;
                align-items: stretch;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <h1><i class="fas fa-calendar"></i> Quản lý lịch</h1>
        <div class="header-nav">
            <a href="/admin/dashboard" class="nav-link">Dashboard</a>
            <a href="/admin/users" class="nav-link">Quản lý người dùng</a>
            <a href="/admin/schedules" class="nav-link active">Quản lý lịch</a>
            <a href="/schedule/add" class="nav-link">Về lịch</a>
            <a href="/auth/logout" class="nav-link">Đăng xuất</a>
        </div>
    </div>

    <div class="container">
        <div class="filter-section">
            <h3 style="margin-bottom: 1rem; color: #1e293b;">Bộ lọc</h3>
            <div class="filter-row">
                <div class="filter-group">
                    <label>Tìm kiếm</label>
                    <input type="text" id="search-input" placeholder="Tìm theo mô tả...">
                </div>
                <div class="filter-group">
                    <label>Người dùng</label>
                    <select id="user-filter">
                        <option value="">Tất cả người dùng</option>
                        <c:forEach var="user" items="${users}">
                            <option value="${user.username}">${user.username}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="filter-group">
                    <label>Ngày</label>
                    <input type="date" id="date-filter">
                </div>
                <div class="filter-group">
                    <label>&nbsp;</label>
                    <button class="btn btn-primary" onclick="applyFilters()">
                        <i class="fas fa-filter"></i> Lọc
                    </button>
                </div>
            </div>
        </div>

        <div class="table-container">
            <div class="table-header">
                <h2>Danh sách lịch cố định (${schedules.size()})</h2>
                <button class="btn btn-primary" onclick="refreshSchedules()">
                    <i class="fas fa-sync"></i> Làm mới
                </button>
            </div>

            <c:choose>
                <c:when test="${empty schedules}">
                    <div class="empty-state">
                        <i class="fas fa-calendar"></i>
                        <h3>Chưa có lịch nào</h3>
                        <p>Hệ thống chưa có lịch cố định nào được tạo.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>Lịch</th>
                                <th>Người tạo</th>
                                <th>Thời gian</th>
                                <th>Ngày</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="schedule" items="${schedules}">
                                <tr>
                                    <td>
                                        <div style="display: flex; align-items: center;">
                                            <div class="schedule-color" style="background-color: ${schedule.color};"></div>
                                            <div>
                                                <div style="font-weight: 500;">${schedule.description}</div>
                                                <div class="time-info">
                                                    ${schedule.startTime} - ${schedule.endTime}
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <c:if test="${schedule.user != null}">
                                            <div class="user-info">
                                                <div class="user-avatar">
                                                    ${schedule.user.username.charAt(0).toUpperCase()}
                                                </div>
                                                <div>
                                                    <div style="font-weight: 500;">${schedule.user.username}</div>
                                                    <div style="font-size: 0.75rem; color: #64748b;">${schedule.user.email}</div>
                                                </div>
                                            </div>
                                        </c:if>
                                        <c:if test="${schedule.user == null}">
                                            <span style="color: #64748b;">Không xác định</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <div style="font-weight: 500;">${schedule.startTime}</div>
                                        <div style="font-size: 0.875rem; color: #64748b;">đến ${schedule.endTime}</div>
                                    </td>
                                    <td>
                                        <div style="font-weight: 500;">${schedule.dayOfWeek}</div>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <a href="/schedule/edit/${schedule.id}" class="btn btn-sm btn-secondary">
                                                <i class="fas fa-edit"></i> Sửa
                                            </a>
                                            <button class="btn btn-sm btn-danger" onclick="deleteSchedule(${schedule.id}, '${schedule.description}')">
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
        function deleteSchedule(scheduleId, description) {
            if (confirm(`Bạn có chắc muốn xóa lịch "${description}"? Hành động này không thể hoàn tác.`)) {
                fetch(`/admin/schedules/${scheduleId}`, {
                    method: 'DELETE'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        showNotification('Xóa lịch thành công!', 'success');
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

        function refreshSchedules() {
            location.reload();
        }

        function applyFilters() {
            const searchTerm = document.getElementById('search-input').value.toLowerCase();
            const userFilter = document.getElementById('user-filter').value;
            const dateFilter = document.getElementById('date-filter').value;

            const rows = document.querySelectorAll('tbody tr');
            
            rows.forEach(row => {
                const description = row.querySelector('td:first-child div:last-child div:first-child').textContent.toLowerCase();
                const user = row.querySelector('td:nth-child(2) .user-info div:last-child div:first-child')?.textContent || '';
                const date = row.querySelector('td:nth-child(4) div:first-child').textContent;

                let show = true;

                if (searchTerm && !description.includes(searchTerm)) {
                    show = false;
                }

                if (userFilter && user !== userFilter) {
                    show = false;
                }

                if (dateFilter && date !== dateFilter) {
                    show = false;
                }

                row.style.display = show ? 'table-row' : 'none';
            });
        }

        // Auto-apply filters on input change
        document.getElementById('search-input').addEventListener('input', applyFilters);
        document.getElementById('user-filter').addEventListener('change', applyFilters);
        document.getElementById('date-filter').addEventListener('change', applyFilters);

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
