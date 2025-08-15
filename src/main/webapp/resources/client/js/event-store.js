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
    console.log("=== EVENT DELETE ===");
    console.log("Deleting event ID:", deletedEvent.id);
    
    // Xóa trên server nếu có ID
    if (deletedEvent.id) {
      try {
        const response = await fetch(`/schedule/api/delete/${deletedEvent.id}`, {
          method: 'POST'
        });
        const result = await response.json();
        console.log("Server delete result:", result);
        
        if (!result.success) {
          console.error("Server delete failed:", result.message);
        }
      } catch (error) {
        console.error("Error deleting from server:", error);
      }
    }
    
    // Xóa trong localStorage
    const events = getEventsFromLocalStorage().filter((event) => {
      // So sánh theo ID nếu có, không thì so sánh theo nội dung
      if (event.id && deletedEvent.id) {
        return event.id !== deletedEvent.id;
      }
      return !(event.title === deletedEvent.title && 
               event.startTime === deletedEvent.startTime && 
               event.endTime === deletedEvent.endTime);
    });
    saveEventsIntoLocalStorage(events);

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
    const events = schedules.map(schedule => ({
      id: schedule.id,
      title: schedule.description,
      description: schedule.description,
      date: new Date(schedule.dayOfWeek), // Sử dụng dayOfWeek từ server
      startTime: schedule.startTime,
      endTime: schedule.endTime,
      color: schedule.color,
      dayOfWeek: schedule.dayOfWeek
    }));
    
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