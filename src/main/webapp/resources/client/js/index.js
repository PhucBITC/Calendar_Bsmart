import { initCalendar } from "./calendar.js";
import { initEventCreateButtons } from "./event-create-button.js";
import { initEventDeleteDialog } from "./event-delete-dialog.js";
import { initEventDetailsDialog } from "./event-details-dialog.js";
import { initEventFormDialog } from "./event-form-dialog.js";
import { initEventStore } from "./event-store.js";
import { initHamburger } from "./hamburger.js";
import { initMiniCalendars } from "./mini-calendar.js";
import { initMobileSidebar } from "./mobile-sidebar.js";
import { initNav } from "./nav.js";
import { initNotifications } from "./notifications.js";
import { initViewSelect } from "./view-select.js";
import { initResponsive } from "./responsive.js";
import { initUrl } from "./url.js";
import { initSync } from "./sync.js";
import { initSmartSchedule } from "./smart-schedule.js";
import { initSmartScheduleButton } from "./smart-schedule-button.js";
import { initCurrentTimeLine } from "./current-time-line.js";
import "./custom.js"; // 👈 thêm dòng này

const eventStore = initEventStore();
window.eventStore = eventStore; // Expose globally for smart-schedule.js
initCalendar(eventStore);
initEventCreateButtons();
initEventDeleteDialog();
initEventDetailsDialog();
initEventFormDialog();
initHamburger();
initMiniCalendars();
initMobileSidebar();
initNav();
initNotifications();
initViewSelect();
initUrl();
initResponsive();
initSync();
initSmartSchedule();
initSmartScheduleButton();
initCurrentTimeLine(); // Khởi tạo đường kẻ thời gian
