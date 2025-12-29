import { isTheSameDay } from "./date.js";

export function initEventStore() {
  document.addEventListener("event-create", (event) => {
    const createdEvent = event.detail.event;
    console.log("=== EVENT CREATE ===");
    console.log("Created event ID:", createdEvent.id);

    const events = getEventsFromLocalStorage();
    events.push(createdEvent);
    saveEventsIntoLocalStorage(events);

    document.dispatchEvent(new CustomEvent("events-change", {
      bubbles: true
    }));
  });

  document.addEventListener("event-delete", async (event) => {
    const deletedEvent = event.detail.event;
    const deleteMode = event.detail.deleteMode || 'single';

    console.log("=== EVENT DELETE ===");
    console.log("Deleting event ID:", deletedEvent.id);
    console.log("Delete Mode:", deleteMode);

    // 1. Xác định danh sách các sự kiện cần xóa
    const allEvents = getEventsFromLocalStorage();
    let eventsToDelete = [];

    if (deleteMode === 'single') {
      eventsToDelete = [deletedEvent];
    } else if (deleteMode === 'weekly') {
      // Tìm các sự kiện cùng tên, cùng giờ, cùng thứ trong tuần
      eventsToDelete = allEvents.filter(e =>
        e.title === deletedEvent.title &&
        e.startTime === deletedEvent.startTime &&
        e.endTime === deletedEvent.endTime &&
        e.date.getDay() === deletedEvent.date.getDay()
      );
    } else if (deleteMode === 'monthly') {
      // Tìm các sự kiện cùng tên, cùng giờ, cùng ngày trong tháng
      eventsToDelete = allEvents.filter(e =>
        e.title === deletedEvent.title &&
        e.startTime === deletedEvent.startTime &&
        e.endTime === deletedEvent.endTime &&
        e.date.getDate() === deletedEvent.date.getDate()
      );
    }

    console.log(`Found ${eventsToDelete.length} events to delete.`);

    // 2. Xóa trên server (gọi API cho từng sự kiện)
    // Lưu ý: Controller dùng @DeleteMapping nên method phải là DELETE
    const deletePromises = eventsToDelete.map(ev => {
      if (ev.id) {
        return fetch(`/schedule/api/delete/${ev.id}`, { method: 'DELETE' })
          .then(res => res.json())
          .catch(err => console.error(`Error deleting event ${ev.id}:`, err));
      }
      return Promise.resolve();
    });

    await Promise.all(deletePromises);

    // 3. Xóa trong localStorage
    // Lấy danh sách ID đã xóa để lọc chính xác
    const deletedIds = new Set(eventsToDelete.map(e => e.id).filter(id => id));

    const remainingEvents = allEvents.filter((e) => {
      if (e.id && deletedIds.has(e.id)) return false;
      // Fallback cho sự kiện chưa có ID (vừa tạo xong chưa sync)
      if (!e.id && deleteMode === 'single') {
        return !(e.title === deletedEvent.title && e.startTime === deletedEvent.startTime && e.date.getTime() === deletedEvent.date.getTime());
      }
      return true;
    });

    saveEventsIntoLocalStorage(remainingEvents);

    document.dispatchEvent(new CustomEvent("events-change", {
      bubbles: true
    }));
  });

  document.addEventListener("event-edit", (event) => {
    const editedEvent = event.detail.event;
    console.log("=== EVENT EDIT ===");
    console.log("Edited event ID:", editedEvent.id);

    const events = getEventsFromLocalStorage().map((event) => {
      // Update theo ID nếu có, không thì theo nội dung
      if (event.id && editedEvent.id) {
        return event.id === editedEvent.id ? editedEvent : event;
      }
      // Fallback: tìm theo title + time (cho trường hợp không có ID)
      if (event.title === editedEvent.title &&
        event.startTime === editedEvent.startTime &&
        event.endTime === editedEvent.endTime) {
        return editedEvent;
      }
      return event;
    });
    saveEventsIntoLocalStorage(events);

    document.dispatchEvent(new CustomEvent("events-change", {
      bubbles: true
    }));
  });

  // Sync data từ server khi load trang
  syncFromServer();

  return {
    getEventsByDate(date) {
      const events = getEventsFromLocalStorage();
      const filteredEvents = events.filter((event) => isTheSameDay(event.date, date));
      return filteredEvents;
    },

    // Thêm method để sync với server
    async syncFromServer() {
      return syncFromServer();
    }
  };
}

// Sync data từ server về localStorage
async function syncFromServer() {
  try {
    console.log("=== SYNCING FROM SERVER ===");
    const response = await fetch('/schedule/api/schedules');
    const schedules = await response.json();

    // Convert schedules từ server thành format của localStorage
    const events = schedules.map(schedule => {
      console.log("Schedule from server:", schedule);
      console.log("startTime type:", typeof schedule.startTime, "value:", schedule.startTime);
      console.log("endTime type:", typeof schedule.endTime, "value:", schedule.endTime);

      return {
        id: schedule.id,
        title: schedule.description,
        description: schedule.description,
        date: new Date(schedule.dayOfWeek), // Sử dụng dayOfWeek từ server
        startTime: schedule.startTime,
        endTime: schedule.endTime,
        color: schedule.color,
        dayOfWeek: schedule.dayOfWeek
      };
    });

    console.log("Synced events from server:", events);
    saveEventsIntoLocalStorage(events);

    // Trigger events-change để refresh UI
    document.dispatchEvent(new CustomEvent("events-change", {
      bubbles: true
    }));

  } catch (error) {
    console.error("Error syncing from server:", error);
  }
}

function saveEventsIntoLocalStorage(events) {
  const safeToStringifyEvents = events.map((event) => ({
    ...event,
    date: event.date.toISOString()
  }));

  let stringifiedEvents;
  try {
    stringifiedEvents = JSON.stringify(safeToStringifyEvents);
  } catch (error) {
    console.error("Stringify events failed", error);
  }

  localStorage.setItem("events", stringifiedEvents);
  console.log("Saved to localStorage:", safeToStringifyEvents);
}

function getEventsFromLocalStorage() {
  const localStorageEvents = localStorage.getItem("events");
  if (localStorageEvents === null) {
    return [];
  }

  let parsedEvents;
  try {
    parsedEvents = JSON.parse(localStorageEvents);
  } catch (error) {
    console.error("Parse events failed", error);
    return [];
  }

  const events = parsedEvents.map((event) => ({
    ...event,
    date: new Date(event.date)
  }));

  return events;
}