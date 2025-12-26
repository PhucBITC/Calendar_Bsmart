/**
 * Module để khởi tạo và quản lý đường kẻ thời gian hiện tại trên lịch tuần.
 */
export function initCurrentTimeLine() {
    /**
     * Sử dụng MutationObserver để đợi cho đến khi lịch tuần (từ <template>) được render vào DOM.
     * Điều này đảm bảo chúng ta không cố gắng truy cập các phần tử chưa tồn tại.
     */
    const observer = new MutationObserver(function (mutations, obs) {
        const weekCalendar = document.querySelector('[data-week-calendar]');
        // Kiểm tra nếu lịch hiển thị và chưa có đường kẻ (tránh trùng lặp khi observer chạy nhiều lần)
        if (weekCalendar && !weekCalendar.querySelector('#current-time-line')) {
            setupCurrentTimeLine(weekCalendar);
        }
        // Không ngắt kết nối observer để nó tiếp tục theo dõi việc chuyển đổi view (Week/Day/Month)
    });

    // Bắt đầu theo dõi các thay đổi bên trong container [data-calendar]
    const calendarContainer = document.querySelector('[data-calendar]');
    if (calendarContainer) {
        observer.observe(calendarContainer, {
            childList: true, // Theo dõi việc thêm/bớt node con
            subtree: true    // Theo dõi cả các node con cháu
        });
    }
}

function setupCurrentTimeLine(calendarElement) {
    // 1. Tự tạo phần tử đường kẻ thay vì dựa vào HTML có sẵn
    const line = document.createElement('div');
    line.id = 'current-time-line';

    // 2. Tìm container của các cột ngày và chèn đường kẻ vào đó
    const columnsContainer = calendarElement.querySelector('[data-week-calendar-columns]');
    if (!columnsContainer) {
        console.error('Không tìm thấy container [data-week-calendar-columns].');
        return;
    }
    columnsContainer.appendChild(line);

    // 3. Tính toán động chiều cao của một giờ
    const timeItems = calendarElement.querySelectorAll('.week-calendar__time-item');
    if (timeItems.length < 2) {
        console.error('Không tìm thấy đủ các mục thời gian để tính toán chiều cao.');
        return;
    }

    const pixelsPerHour = timeItems[1].getBoundingClientRect().top - timeItems[0].getBoundingClientRect().top;
    const pixelsPerMinute = pixelsPerHour / 60;

    // 4. Hàm cập nhật vị trí, được gọi liên tục bởi requestAnimationFrame
    function update() {
        // Nếu đường kẻ bị xóa khỏi DOM (do chuyển view), dừng vòng lặp cập nhật
        if (!line.isConnected) {
            return;
        }

        const now = new Date();
        const minutesFromMidnight = now.getHours() * 60 + now.getMinutes() + now.getSeconds() / 60;
        line.style.top = `${minutesFromMidnight * pixelsPerMinute}px`;
        requestAnimationFrame(update);
    }

    // Bắt đầu vòng lặp cập nhật
    update();
}