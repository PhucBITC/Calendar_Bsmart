import { validateEvent, generateEventId } from "./event.js";

export function initEventForm(toaster) {
  const formElement = document.querySelector("[data-event-form]");

  let mode = "create";

  formElement.addEventListener("submit", async (e) => {
    e.preventDefault();

    const formEvent = formIntoEvent(formElement);
    const validationError = validateEvent(formEvent);
    if (validationError !== null) {
      toaster.error(validationError);
      return;
    }

    try {
      // Gửi dữ liệu lên server qua API
      const formData = new FormData(formElement);
      
      const response = await fetch('/schedule/api/save', {
        method: 'POST',
        body: formData
      });

      const result = await response.json();

      if (result.success) {
        // Lấy event với ID thật từ database
        const savedEvent = result.data;
        
        if (result.isRepeating && Array.isArray(savedEvent)) {
          // Xử lý multiple schedules (repeating)
          console.log("=== SAVED REPEATING EVENTS ===");
          console.log("Number of schedules:", savedEvent.length);
          
          // Tạo events cho tất cả schedules
          const eventsWithRealIds = savedEvent.map(schedule => ({
            id: schedule.id,
            title: schedule.description,
            description: schedule.description,
            date: new Date(schedule.dayOfWeek),
            startTime: schedule.startTime,
            endTime: schedule.endTime,
            color: schedule.color,
            dayOfWeek: schedule.dayOfWeek
          }));

          // Dispatch events cho từng schedule
          eventsWithRealIds.forEach(event => {
            document.dispatchEvent(new CustomEvent("event-create", {
              detail: { event: event },
              bubbles: true
            }));
          });

          toaster.success(`Đã tạo ${savedEvent.length} lịch trình lặp lại!`);
        } else {
          // Xử lý single schedule
          const eventWithRealId = {
            ...formEvent,
            id: savedEvent.id,
            title: savedEvent.description,
            description: savedEvent.description,
            date: new Date(savedEvent.dayOfWeek),
            startTime: savedEvent.startTime,
            endTime: savedEvent.endTime,
            color: savedEvent.color,
            dayOfWeek: savedEvent.dayOfWeek
          };

          console.log("=== SAVED EVENT ===");
          console.log("Database ID:", savedEvent.id);
          console.log("Event object:", eventWithRealId);

          // Cập nhật localStorage với ID đúng
          if (mode === "create") {
            document.dispatchEvent(new CustomEvent("event-create", {
              detail: { event: eventWithRealId },
              bubbles: true
            }));
          } else if (mode === "edit") {
            document.dispatchEvent(new CustomEvent("event-edit", {
              detail: { event: eventWithRealId },
              bubbles: true
            }));
          }

          toaster.success("Schedule saved successfully!");
        }
        
        // Close dialog
        const dialog = formElement.closest('[data-dialog]');
        if (dialog) {
          dialog.close();
        }

      } else {
        toaster.error(result.message || "Error saving schedule");
      }

    } catch (error) {
      console.error("Save error:", error);
      toaster.error("Network error while saving");
    }
  });

  return {
    formElement,
    switchToCreateMode(date, startTime, endTime) {
      mode = "create";
      fillFormWithDate(formElement, date, startTime, endTime);
      
      // Clear ID cho create mode
      const idInput = formElement.querySelector("#id");
      if (idInput) {
        idInput.value = "";
      }
    },
    switchToEditMode(event) {
      mode = "edit";
      console.log("=== EDIT MODE ===");
      console.log("Event ID:", event.id);
      console.log("Full event:", event);
      
      fillFormWithEvent(formElement, event);
    },
    reset() {
      const idInput = formElement.querySelector("#id");
      if (idInput) idInput.value = "";
      formElement.reset();
    }
  };
}

function fillFormWithDate(formElement, date, startTime, endTime) {
  formElement.querySelector("#date").value = date.toISOString().substr(0, 10);
  formElement.querySelector("#start-time").value = startTime;
  formElement.querySelector("#end-time").value = endTime;
}

function fillFormWithEvent(formElement, event) {
  console.log("=== FILL FORM WITH EVENT ===");
  console.log("Event ID:", event.id);
  console.log("Event title/description:", event.title || event.description);
  
  // Set ID - Nếu không có ID thì call API để lấy
  const idInput = formElement.querySelector("#id");
  if (event.id) {
    idInput.value = event.id;
  } else {
    // Nếu localStorage không có ID, thử tìm trong database
    findEventIdInDatabase(event).then(foundId => {
      if (foundId) {
        idInput.value = foundId;
        console.log("Found ID in database:", foundId);
      }
    });
  }
  
  formElement.querySelector("#title").value = event.title || event.description || "";
  
  // Handle date
  if (event.date) {
    const dateStr = event.date instanceof Date ? 
      event.date.toISOString().substr(0, 10) : 
      new Date(event.date).toISOString().substr(0, 10);
    formElement.querySelector("#date").value = dateStr;
  }
  
  formElement.querySelector("#start-time").value = event.startTime || "";
  formElement.querySelector("#end-time").value = event.endTime || "";
  
  // Set color
  const colorInput = formElement.querySelector(`[value='${event.color}']`);
  if (colorInput) {
    colorInput.checked = true;
  }
}

// Helper function để tìm ID trong database
async function findEventIdInDatabase(event) {
  try {
    const response = await fetch('/schedule/api/schedules');
    const schedules = await response.json();
    
    // Tìm schedule trùng khớp với event
    const found = schedules.find(schedule => 
      schedule.description === (event.title || event.description) &&
      schedule.startTime === event.startTime &&
      schedule.endTime === event.endTime &&
      schedule.color === event.color
    );
    
    return found ? found.id : null;
  } catch (error) {
    console.error("Error finding event ID:", error);
    return null;
  }
}

function formIntoEvent(formElement) {
  const formData = new FormData(formElement);
  const id = formData.get("id");
  const title = formData.get("description");
  const date = formData.get("dayOfWeek") || formElement.querySelector("#date").value;
  const startTime = formData.get("startTime");
  const endTime = formData.get("endTime");
  const color = formData.get("color");

  return {
    id: id && id !== "" ? Number.parseInt(id, 10) : null,
    title: title,
    description: title,
    date: new Date(date),
    startTime: startTime,
    endTime: endTime,
    color: color
  };
}