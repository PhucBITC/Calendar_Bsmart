<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <title>BSmart Calendar - Lịch thông minh</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --primary-color: #2563eb;
            --secondary-color: #64748b;
            --success-color: #16a34a;
            --danger-color: #dc2626;
            --warning-color: #ea580c;
            --info-color: #0891b2;
            --light-bg: #f8fafc;
            --dark-bg: #1e293b;
            --light-text: #334155;
            --dark-text: #f1f5f9;
            --border-color: #e2e8f0;
            --shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
        }

        [data-theme="dark"] {
            --primary-color: #3b82f6;
            --secondary-color: #94a3b8;
            --light-bg: #1e293b;
            --dark-bg: #0f172a;
            --light-text: #f1f5f9;
            --dark-text: #334155;
            --border-color: #334155;
            --shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.3);
        }

        body {
            background-color: var(--light-bg);
            color: var(--light-text);
            transition: all 0.3s ease;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        [data-theme="dark"] body {
            background-color: var(--dark-bg);
            color: var(--dark-text);
        }

        /* Header Styles */
        .header {
            background: white;
            border-bottom: 1px solid var(--border-color);
            padding: 1rem 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: var(--shadow);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        [data-theme="dark"] .header {
            background: var(--dark-bg);
            border-bottom-color: var(--border-color);
        }

        .header-left, .header-right {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .search-box {
            position: relative;
            min-width: 300px;
        }

        .search-box input {
            width: 100%;
            padding: 0.5rem 1rem 0.5rem 2.5rem;
            border: 1px solid var(--border-color);
            border-radius: 0.5rem;
            background: var(--light-bg);
            color: var(--light-text);
            font-size: 0.875rem;
        }

        .search-box i {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--secondary-color);
        }

        .theme-toggle {
            background: none;
            border: none;
            font-size: 1.25rem;
            color: var(--secondary-color);
            cursor: pointer;
            padding: 0.5rem;
            border-radius: 0.5rem;
            transition: all 0.2s;
        }

        .theme-toggle:hover {
            background: var(--border-color);
        }

        /* Profile Dropdown */
        .profile-dropdown {
            position: relative;
            display: inline-block;
        }

        .profile-btn {
            background: none;
            border: none;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            cursor: pointer;
            transition: all 0.2s;
            color: var(--light-text);
        }

        .profile-btn:hover {
            background: var(--border-color);
        }

        .profile-avatar {
            width: 2rem;
            height: 2rem;
            border-radius: 50%;
            background: var(--primary-color);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 0.875rem;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            top: 100%;
            background: white;
            min-width: 200px;
            box-shadow: var(--shadow);
            border-radius: 0.5rem;
            z-index: 1000;
            border: 1px solid var(--border-color);
            margin-top: 0.5rem;
        }

        [data-theme="dark"] .dropdown-content {
            background: var(--dark-bg);
            border-color: var(--border-color);
        }

        .dropdown-content.show {
            display: block;
        }

        .dropdown-item {
            display: block;
            padding: 0.75rem 1rem;
            text-decoration: none;
            color: var(--light-text);
            transition: background 0.2s;
            font-size: 0.875rem;
        }

        .dropdown-item:hover {
            background: var(--border-color);
        }

        .dropdown-divider {
            height: 1px;
            background: var(--border-color);
            margin: 0.5rem 0;
        }

        .auth-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 0.5rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s;
            font-size: 0.875rem;
        }

        .btn-primary {
            background: var(--primary-color);
            color: white;
        }

        .btn-primary:hover {
            opacity: 0.9;
        }

        .btn-secondary {
            background: var(--secondary-color);
            color: white;
        }

        .btn-secondary:hover {
            opacity: 0.9;
        }

        .btn-outline {
            background: transparent;
            color: var(--primary-color);
            border: 1px solid var(--primary-color);
        }

        .btn-outline:hover {
            background: var(--primary-color);
            color: white;
        }

        /* App Layout */
        .app {
            display: flex;
            height: calc(100vh - 80px);
        }

        .sidebar {
            width: 280px;
            background: white;
            border-right: 1px solid var(--border-color);
            padding: 1.5rem;
            overflow-y: auto;
        }

        [data-theme="dark"] .sidebar {
            background: var(--dark-bg);
            border-right-color: var(--border-color);
        }

        .sidebar__logo {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 2rem;
            color: var(--primary-color);
            font-weight: bold;
            font-size: 1.125rem;
        }

        .button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 0.5rem;
            cursor: pointer;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s;
            font-size: 0.875rem;
            width: 100%;
            justify-content: center;
        }

        .button--primary {
            background: var(--primary-color);
            color: white;
        }

        .button--primary:hover {
            background: #1d4ed8;
        }

        .button--secondary {
            background: var(--secondary-color);
            color: white;
        }

        .button--secondary:hover {
            background: #475569;
        }

        .button--lg {
            padding: 1rem 1.5rem;
            font-size: 1rem;
        }

        /* Settings Section */
        .settings-section {
            margin-top: 2rem;
            padding-top: 1rem;
            border-top: 1px solid var(--border-color);
        }

        .settings-title {
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--secondary-color);
            margin-bottom: 0.75rem;
        }

        .settings-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.5rem 0;
        }

        .settings-label {
            font-size: 0.875rem;
        }

        .toggle-switch {
            position: relative;
            width: 3rem;
            height: 1.5rem;
        }

        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: var(--border-color);
            transition: .4s;
            border-radius: 1.5rem;
        }

        .slider:before {
            position: absolute;
            content: "";
            height: 1.25rem;
            width: 1.25rem;
            left: 0.125rem;
            bottom: 0.125rem;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }

        input:checked + .slider {
            background-color: var(--primary-color);
        }

        input:checked + .slider:before {
            transform: translateX(1.5rem);
        }

        /* Main Content */
        .main-content {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .nav {
            background: white;
            border-bottom: 1px solid var(--border-color);
            padding: 1rem 1.5rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        [data-theme="dark"] .nav {
            background: var(--dark-bg);
            border-bottom-color: var(--border-color);
        }

        .nav__date-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .nav__controls {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .nav__arrows {
            display: flex;
            gap: 0.25rem;
        }

        .nav__date {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--light-text);
        }

        .calendar-container {
            flex: 1;
            padding: 1.5rem;
            overflow-y: auto;
        }

        /* Calendar Styles */
        .calendar {
            background: white;
            border-radius: 0.75rem;
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        [data-theme="dark"] .calendar {
            background: var(--dark-bg);
        }

        .calendar__header {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            background: var(--light-bg);
            border-bottom: 1px solid var(--border-color);
        }

        [data-theme="dark"] .calendar__header {
            background: var(--dark-bg);
        }

        .calendar__day-header {
            padding: 1rem;
            text-align: center;
            font-weight: 600;
            color: var(--secondary-color);
            font-size: 0.875rem;
        }

        .calendar__body {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            min-height: 400px;
        }

        .calendar__day {
            border-right: 1px solid var(--border-color);
            border-bottom: 1px solid var(--border-color);
            padding: 0.5rem;
            min-height: 80px;
            position: relative;
        }

        .calendar__day:nth-child(7n) {
            border-right: none;
        }

        .calendar__day-number {
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .calendar__day--today {
            background: var(--primary-color);
            color: white;
        }

        .calendar__day--today .calendar__day-number {
            color: white;
        }

        .calendar__day--other-month {
            opacity: 0.5;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .header {
                padding: 1rem;
                flex-direction: column;
                gap: 1rem;
            }

            .search-box {
                min-width: auto;
                width: 100%;
            }

            .sidebar {
                display: none;
            }

            .sidebar.show {
                display: block;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                z-index: 1000;
            }
        }
    </style>
</head>

<body>
    <div class="header">
        <div class="header-left">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" id="search-input" placeholder="Tìm kiếm lịch...">
            </div>
        </div>
        <div class="header-right">
            <button class="theme-toggle" id="theme-toggle" title="Chuyển đổi giao diện">
                <i class="fas fa-moon"></i>
            </button>
            <div class="profile-dropdown" id="profile-dropdown">
                <button class="profile-btn" id="profile-btn">
                    <div class="profile-avatar" id="profile-avatar">U</div>
                    <span id="profile-name">User</span>
                    <i class="fas fa-chevron-down"></i>
                </button>
                <div class="dropdown-content" id="dropdown-content">
                    <a href="/auth/profile" class="dropdown-item">
                        <i class="fas fa-user"></i> Hồ sơ cá nhân
                    </a>
                    <a href="/admin/dashboard" class="dropdown-item admin-link" style="display: none;">
                        <i class="fas fa-cog"></i> Quản trị hệ thống
                    </a>
                    <div class="dropdown-divider"></div>
                    <a href="/auth/logout" class="dropdown-item">
                        <i class="fas fa-sign-out-alt"></i> Đăng xuất
                    </a>
                </div>
            </div>
            <div class="auth-buttons" id="auth-buttons" style="display: none;">
                <a href="/auth/login" class="btn btn-outline">Đăng nhập</a>
                <a href="/auth/register" class="btn btn-primary">Đăng ký</a>
            </div>
        </div>
    </div>

    <div class="app">
        <div class="sidebar" id="sidebar">
            <div class="sidebar__logo">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none"
                    stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M8 2v4" />
                    <path d="M16 2v4" />
                    <rect width="18" height="18" x="3" y="4" rx="2" />
                    <path d="M3 10h18" />
                </svg>
                <span>BSmart Calendar</span>
            </div>

            <button class="button button--primary button--lg" id="create-event-btn">
                <i class="fas fa-plus"></i> Tạo lịch mới
            </button>
            
            <button class="button button--secondary button--lg" id="generate-smart" style="margin-top: 1rem;">
                <i class="fas fa-magic"></i> Sinh lịch thông minh
            </button>

            <div class="settings-section">
                <div class="settings-title">
                    <i class="fas fa-cog"></i> Cài đặt thông báo
                </div>
                <div class="settings-item">
                    <span class="settings-label">Thông báo web</span>
                    <label class="toggle-switch">
                        <input type="checkbox" id="web-notifications" checked>
                        <span class="slider"></span>
                    </label>
                </div>
                <div class="settings-item">
                    <span class="settings-label">Thông báo email</span>
                    <label class="toggle-switch">
                        <input type="checkbox" id="email-notifications" checked>
                        <span class="slider"></span>
                    </label>
                </div>
                <div class="settings-item">
                    <span class="settings-label">Âm thanh nhắc</span>
                    <label class="toggle-switch">
                        <input type="checkbox" id="sound-notifications" checked>
                        <span class="slider"></span>
                    </label>
                </div>
            </div>
        </div>

        <div class="main-content">
            <div class="nav">
                <div class="nav__date-info">
                    <div class="nav__controls">
                        <button class="btn btn-secondary" id="today-btn">Hôm nay</button>
                        <div class="nav__arrows">
                            <button class="btn btn-secondary" id="prev-btn">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                            <button class="btn btn-secondary" id="next-btn">
                                <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                    <div class="nav__date" id="current-date">Tháng 8, 2025</div>
                </div>
                <div>
                    <select id="view-select" class="btn btn-secondary">
                        <option value="month">Tháng</option>
                        <option value="week">Tuần</option>
                        <option value="day">Ngày</option>
                    </select>
                </div>
            </div>
            
            <div class="calendar-container">
                <div class="calendar" id="calendar">
                    <!-- Calendar will be generated by JavaScript -->
                </div>
            </div>
        </div>
    </div>

    <!-- Event Form Modal -->
    <div id="event-modal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000;">
        <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); background: white; padding: 2rem; border-radius: 0.5rem; min-width: 400px;">
            <h3 style="margin-bottom: 1rem;">Tạo lịch mới</h3>
            <form id="event-form">
                <div style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.5rem;">Mô tả:</label>
                    <input type="text" id="event-description" required style="width: 100%; padding: 0.5rem; border: 1px solid #ccc; border-radius: 0.25rem;">
                </div>
                <div style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.5rem;">Ngày:</label>
                    <input type="date" id="event-date" required style="width: 100%; padding: 0.5rem; border: 1px solid #ccc; border-radius: 0.25rem;">
                </div>
                <div style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.5rem;">Giờ bắt đầu:</label>
                    <input type="time" id="event-start-time" required style="width: 100%; padding: 0.5rem; border: 1px solid #ccc; border-radius: 0.25rem;">
                </div>
                <div style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.5rem;">Giờ kết thúc:</label>
                    <input type="time" id="event-end-time" required style="width: 100%; padding: 0.5rem; border: 1px solid #ccc; border-radius: 0.25rem;">
                </div>
                <div style="margin-bottom: 1rem;">
                    <label style="display: block; margin-bottom: 0.5rem;">Màu sắc:</label>
                    <input type="color" id="event-color" value="#2563eb" style="width: 100%; padding: 0.5rem; border: 1px solid #ccc; border-radius: 0.25rem;">
                </div>
                <div style="display: flex; gap: 1rem; justify-content: flex-end;">
                    <button type="button" id="cancel-btn" class="btn btn-secondary">Hủy</button>
                    <button type="submit" class="btn btn-primary">Lưu</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Theme management
        const themeToggle = document.getElementById('theme-toggle');
        const body = document.body;
        const currentTheme = localStorage.getItem('theme') || 'light';
        
        body.setAttribute('data-theme', currentTheme);
        updateThemeIcon(currentTheme);

        themeToggle.addEventListener('click', () => {
            const newTheme = body.getAttribute('data-theme') === 'light' ? 'dark' : 'light';
            body.setAttribute('data-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            updateThemeIcon(newTheme);
        });

        function updateThemeIcon(theme) {
            const icon = themeToggle.querySelector('i');
            icon.className = theme === 'light' ? 'fas fa-moon' : 'fas fa-sun';
        }

        // Profile dropdown
        const profileBtn = document.getElementById('profile-btn');
        const dropdownContent = document.getElementById('dropdown-content');
        const profileDropdown = document.getElementById('profile-dropdown');

        profileBtn.addEventListener('click', (e) => {
            e.stopPropagation();
            dropdownContent.classList.toggle('show');
        });

        document.addEventListener('click', (e) => {
            if (!profileDropdown.contains(e.target)) {
                dropdownContent.classList.remove('show');
            }
        });

        // Calendar functionality
        let currentDate = new Date();
        let currentView = 'month';

        function renderCalendar() {
            const calendar = document.getElementById('calendar');
            const currentDateElement = document.getElementById('current-date');
            
            // Update current date display
            const options = { year: 'numeric', month: 'long' };
            currentDateElement.textContent = currentDate.toLocaleDateString('vi-VN', options);
            
            if (currentView === 'month') {
                renderMonthView(calendar);
            }
        }

        function renderMonthView(calendar) {
            const year = currentDate.getFullYear();
            const month = currentDate.getMonth();
            
            const firstDay = new Date(year, month, 1);
            const lastDay = new Date(year, month + 1, 0);
            const startDate = new Date(firstDay);
            startDate.setDate(startDate.getDate() - firstDay.getDay());
            
            let html = `
                <div class="calendar__header">
                    <div class="calendar__day-header">CN</div>
                    <div class="calendar__day-header">T2</div>
                    <div class="calendar__day-header">T3</div>
                    <div class="calendar__day-header">T4</div>
                    <div class="calendar__day-header">T5</div>
                    <div class="calendar__day-header">T6</div>
                    <div class="calendar__day-header">T7</div>
                </div>
                <div class="calendar__body">
            `;
            
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            
            for (let i = 0; i < 42; i++) {
                const date = new Date(startDate);
                date.setDate(startDate.getDate() + i);
                
                const isToday = date.getTime() === today.getTime();
                const isCurrentMonth = date.getMonth() === month;
                const isOtherMonth = !isCurrentMonth;
                
                html += `
                    <div class="calendar__day ${isToday ? 'calendar__day--today' : ''} ${isOtherMonth ? 'calendar__day--other-month' : ''}" 
                         data-date="${date.toISOString().split('T')[0]}">
                        <div class="calendar__day-number">${date.getDate()}</div>
                    </div>
                `;
            }
            
            html += '</div>';
            calendar.innerHTML = html;
            
            // Add click event to days
            const days = calendar.querySelectorAll('.calendar__day');
            days.forEach(day => {
                day.addEventListener('click', () => {
                    const date = day.getAttribute('data-date');
                    openEventModal(date);
                });
            });
        }

        // Navigation
        document.getElementById('prev-btn').addEventListener('click', () => {
            if (currentView === 'month') {
                currentDate.setMonth(currentDate.getMonth() - 1);
            }
            renderCalendar();
        });

        document.getElementById('next-btn').addEventListener('click', () => {
            if (currentView === 'month') {
                currentDate.setMonth(currentDate.getMonth() + 1);
            }
            renderCalendar();
        });

        document.getElementById('today-btn').addEventListener('click', () => {
            currentDate = new Date();
            renderCalendar();
        });

        // View selector
        document.getElementById('view-select').addEventListener('change', (e) => {
            currentView = e.target.value;
            renderCalendar();
        });

        // Event modal
        function openEventModal(date = null) {
            const modal = document.getElementById('event-modal');
            const dateInput = document.getElementById('event-date');
            
            if (date) {
                dateInput.value = date;
            } else {
                dateInput.value = new Date().toISOString().split('T')[0];
            }
            
            modal.style.display = 'block';
        }

        document.getElementById('create-event-btn').addEventListener('click', () => {
            openEventModal();
        });

        document.getElementById('cancel-btn').addEventListener('click', () => {
            document.getElementById('event-modal').style.display = 'none';
        });

        // Event form submission
        document.getElementById('event-form').addEventListener('submit', async (e) => {
            e.preventDefault();
            
            const formData = {
                description: document.getElementById('event-description').value,
                dayOfWeek: document.getElementById('event-date').value,
                startTime: document.getElementById('event-start-time').value,
                endTime: document.getElementById('event-end-time').value,
                color: document.getElementById('event-color').value
            };
            
            try {
                const response = await fetch('/schedule/api/save', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: new URLSearchParams(formData)
                });
                
                const result = await response.json();
                
                if (result.success) {
                    alert('Lịch đã được tạo thành công!');
                    document.getElementById('event-modal').style.display = 'none';
                    document.getElementById('event-form').reset();
                    // Refresh calendar if needed
                } else {
                    alert('Lỗi: ' + result.message);
                }
            } catch (error) {
                alert('Lỗi kết nối mạng');
            }
        });

        // Generate smart schedule
        document.getElementById('generate-smart').addEventListener('click', async () => {
            try {
                const response = await fetch('/schedule/api/generate', {
                    method: 'POST'
                });
                
                const result = await response.json();
                
                if (result.success) {
                    const suggestions = result.data || [];
                    if (suggestions.length === 0) {
                        alert('Không có gợi ý phù hợp. Hãy tạo thêm Task với deadline và duration.');
                        return;
                    }
                    
                    const message = suggestions.map(item => 
                        `📅 ${item.taskTitle}\n   📆 ${item.dayOfWeek} ${item.startTime}-${item.endTime}\n   ⭐ ${item.priority}`
                    ).join('\n\n');
                    
                    alert('Gợi ý lịch thông minh (EDF + Greedy):\n\n' + message);
                } else {
                    alert('Lỗi: ' + result.message);
                }
            } catch (error) {
                alert('Lỗi kết nối mạng');
            }
        });

        // Settings toggles
        const webNotifications = document.getElementById('web-notifications');
        const emailNotifications = document.getElementById('email-notifications');
        const soundNotifications = document.getElementById('sound-notifications');

        // Load settings from localStorage
        webNotifications.checked = localStorage.getItem('web-notifications') !== 'false';
        emailNotifications.checked = localStorage.getItem('email-notifications') !== 'false';
        soundNotifications.checked = localStorage.getItem('sound-notifications') !== 'false';

        // Save settings to localStorage
        webNotifications.addEventListener('change', () => {
            localStorage.setItem('web-notifications', webNotifications.checked);
        });

        emailNotifications.addEventListener('change', () => {
            localStorage.setItem('email-notifications', emailNotifications.checked);
        });

        soundNotifications.addEventListener('change', () => {
            localStorage.setItem('sound-notifications', soundNotifications.checked);
        });

        // Load user info
        async function loadUserInfo() {
            try {
                const response = await fetch('/auth/api/current-user');
                if (response.ok) {
                    const user = await response.json();
                    document.getElementById('profile-name').textContent = user.username || 'User';
                    document.getElementById('profile-avatar').textContent = (user.username || 'U').charAt(0).toUpperCase();
                    
                    // Show admin link if user is admin
                    if (user.role === 'ADMIN') {
                        document.querySelector('.admin-link').style.display = 'block';
                    }
                } else {
                    // User not logged in, show auth buttons
                    document.getElementById('profile-dropdown').style.display = 'none';
                    document.getElementById('auth-buttons').style.display = 'flex';
                }
            } catch (error) {
                console.error('Error loading user info:', error);
            }
        }

        // Search functionality
        document.getElementById('search-input').addEventListener('input', (e) => {
            const query = e.target.value.toLowerCase();
            // Implement search logic here
        });

        // Initialize
        loadUserInfo();
        renderCalendar();
    </script>
</body>
</html>
