/**
 * Module này tiêm CSS vào trang để làm đẹp giao diện lịch
 * Phong cách: Modern Clean, Soft Shadows, Better Typography
 */
export function initCalendarTheme() {
    const style = document.createElement('style');
    style.textContent = `
      :root {
        /* Bảng màu Modern (Slate & Indigo) */
        --primary-color: #4f46e5;    /* Indigo 600 - Đậm đà hơn */
        --primary-soft: #eef2ff;     /* Indigo 50 - Nền nhạt */
        --bg-body: #f3f4f6;          /* Gray 100 */
        --bg-surface: #ffffff;       /* Trắng tinh */
        --text-main: #1f2937;        /* Gray 800 */
        --text-secondary: #6b7280;   /* Gray 500 */
        --border-color: #e5e7eb;     /* Gray 200 */
        --grid-line: #f1f5f9;        /* Slate 100 */
        --accent-color: #f43f5e;     /* Rose 500 - Giờ hiện tại */
        
        /* Hiệu ứng */
        --shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
        --shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1);
        --shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -2px rgb(0 0 0 / 0.05);
        --radius-md: 12px;
        --radius-lg: 16px;
      }
  
      /* 1. Tổng quan & Scrollbar */
      body {
        background-color: var(--bg-body);
        color: var(--text-main);
        font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        -webkit-font-smoothing: antialiased;
      }

      /* Custom Scrollbar cho đẹp */
      ::-webkit-scrollbar {
        width: 8px;
        height: 8px;
      }
      ::-webkit-scrollbar-track {
        background: transparent;
      }
      ::-webkit-scrollbar-thumb {
        background: #cbd5e1;
        border-radius: 4px;
      }
      ::-webkit-scrollbar-thumb:hover {
        background: #94a3b8;
      }
  
      /* 2. Khung lịch chính */
      [data-calendar] {
        background-color: var(--bg-surface);
        border-radius: var(--radius-lg);
        box-shadow: var(--shadow-md);
        border: 1px solid white; /* Viền trắng tạo cảm giác nổi 3D nhẹ */
        overflow: hidden;
        margin-top: 24px;
      }
  
      /* 3. Header (Ngày trong tuần) */
      [data-week-calendar-day-of-week-list] {
        background-color: var(--bg-surface);
        border-bottom: 1px solid var(--border-color);
        padding: 12px 0;
      }
  
      .week-calendar__day-of-week-button {
        border-radius: var(--radius-md);
        padding: 8px 4px;
        margin: 0 6px;
        transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        border: 1px solid transparent;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 4px;
      }
  
      .week-calendar__day-of-week-button:hover {
        background-color: var(--primary-soft);
        color: var(--primary-color);
      }

      /* Typography cho Header */
      .week-calendar__day-of-week-day {
        font-size: 0.75rem;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        color: var(--text-secondary);
      }
      
      .week-calendar__day-of-week-number {
        font-size: 1.25rem;
        font-weight: 700;
      }
  
      /* Ngày được chọn */
      .week-calendar__day-of-week-button--selected {
        background-color: var(--primary-color) !important;
        box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3); /* Bóng đổ màu tím */
        transform: translateY(-2px);
      }
      
      .week-calendar__day-of-week-button--selected * {
        color: white !important;
      }
  
      /* Ngày hôm nay (Highlight) - Dùng hình tròn đỏ */
      .week-calendar__day-of-week-button--highlight .week-calendar__day-of-week-number {
        background-color: var(--accent-color);
        color: white;
        border-radius: 50%;
        width: 32px;
        height: 32px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-top: 2px;
        box-shadow: 0 2px 6px rgba(244, 63, 94, 0.4);
      }
  
      /* 4. Cột giờ bên trái */
      .week-calendar__time-list {
        background-color: #fafafa; /* Nền hơi xám nhẹ để tách biệt */
        border-right: 1px solid var(--border-color);
      }
  
      .week-calendar__time-item {
        height: 60px !important;
        position: relative;
      }
  
      .week-calendar__time {
        color: var(--text-secondary);
        font-size: 11px;
        font-weight: 500;
        position: absolute;
        top: -8px; /* Căn chỉnh lại cho khớp dòng kẻ */
        right: 12px;
      }
  
      /* 5. Ô lưới lịch - Clean Grid */
      [data-week-calendar-column] {
        border-right: 1px solid var(--grid-line);
      }
  
      [data-week-calendar-cell] {
        /* Dùng nét đứt (dashed) cho các đường ngang để đỡ rối mắt */
        border-bottom: 1px dashed var(--grid-line); 
        height: 60px !important;
        box-sizing: border-box; /* Cực kỳ quan trọng để không bị lệch giờ */
        transition: background-color 0.1s;
      }
  
      [data-week-calendar-cell]:hover {
        background-color: var(--primary-soft); /* Hover màu xanh tím nhạt */
        cursor: pointer;
      }
  
      /* 6. Sự kiện (Event) - Card Style */
      .event {
        border-radius: 8px;
        padding: 6px 10px;
        font-size: 12px;
        font-weight: 600;
        line-height: 1.4;
        border: none;
        box-shadow: 0 2px 4px rgba(0,0,0,0.06); /* Bóng đổ nhẹ */
        transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        overflow: hidden;
        color: black;
        /* Thêm chút hiệu ứng mờ nếu muốn giống kính (Glassmorphism) */
        backdrop-filter: blur(4px);
      }
  
      .event:hover {
        transform: translateY(-2px) scale(1.02); /* Nhấc nhẹ lên khi hover */
        box-shadow: var(--shadow-lg);
        z-index: 50;
        cursor: pointer;
        filter: brightness(1.05); /* Sáng hơn chút khi hover */
      }
  
      .event--filled {
        /* Tạo viền trái đậm hơn chút để làm điểm nhấn */
        border-left: 3px solid rgba(255,255,255,0.3);
      }
      
      /* 7. Đường kẻ giờ hiện tại - Glowing Effect */
      #current-time-line {
        background-color: var(--accent-color);
        height: 2px;
        z-index: 20;
        /* Hiệu ứng phát sáng */
        box-shadow: 0 0 8px rgba(244, 63, 94, 0.6); 
        pointer-events: none; /* Để không chặn click */
      }
  
      #current-time-line::before {
        content: '';
        position: absolute;
        left: -6px;
        top: -5px;
        width: 12px;
        height: 12px;
        background-color: var(--accent-color);
        border-radius: 50%;
        /* Vòng halo xung quanh chấm đỏ */
        box-shadow: 0 0 0 3px rgba(244, 63, 94, 0.2); 
      }
    `;
    document.head.appendChild(style);
}