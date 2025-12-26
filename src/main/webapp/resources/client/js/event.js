const eventTemplateElement = document.querySelector("[data-template='event']");

const dateFormatter = new Intl.DateTimeFormat("en-US", {
  hour: "numeric",
  minute: "numeric"
});

export function initStaticEvent(parent, event) {
  const eventElement = initEvent(event);

  if (isEventAllDay(event)) {
    eventElement.classList.add("event--filled");
  }

  parent.appendChild(eventElement);
}

export function initDynamicEvent(parent, event, dynamicStyles) {
  const eventElement = initEvent(event);

  eventElement.classList.add("event--filled");
  eventElement.classList.add("event--dynamic");

  eventElement.style.top = dynamicStyles.top;
  eventElement.style.left = dynamicStyles.left;
  eventElement.style.bottom = dynamicStyles.bottom;
  eventElement.style.right = dynamicStyles.right;
  if (dynamicStyles.height) {
    eventElement.style.height = dynamicStyles.height;
  }

  eventElement.dataset.eventDynamic = true;

  parent.appendChild(eventElement);
}

function initEvent(event) {
  const eventContent = eventTemplateElement.content.cloneNode(true);
  const eventElement = eventContent.querySelector("[data-event]");
  const eventTitleElement = eventElement.querySelector("[data-event-title]");
  const eventStartTimeElement = eventElement.querySelector("[data-event-start-time]");
  const eventEndTimeElement = eventElement.querySelector("[data-event-end-time]");

  const startDate = eventTimeToDate(event, event.startTime);
  const endDate = eventTimeToDate(event, event.endTime);

  eventElement.style.setProperty("--event-color", event.color);
  eventTitleElement.textContent = event.title;
  eventStartTimeElement.textContent = dateFormatter.format(startDate);
  eventEndTimeElement.textContent = dateFormatter.format(endDate);

  eventElement.addEventListener("click", () => {
    eventElement.dispatchEvent(new CustomEvent("event-click", {
      detail: {
        event,
      },
      bubbles: true
    }));
  });

  return eventElement;
}

export function isEventAllDay(event) {
  const startTimeMinutes = timeStringToMinutes(event.startTime);
  const endTimeMinutes = timeStringToMinutes(event.endTime);
  return startTimeMinutes === 0 && endTimeMinutes === 1440;
}

// EXPORTED: Helper function to convert time to minutes
export function timeStringToMinutes(time) {
  if (typeof time === "number") {
    return time; // Already in minutes
  }

  if (typeof time === "string") {
    // Handle "4:24 PM" format
    if (time.includes("AM") || time.includes("PM")) {
      const [timePart, period] = time.split(" ");
      const [hours, minutes] = timePart.split(":").map(Number);
      let hour24 = hours;

      if (period === "PM" && hours !== 12) {
        hour24 += 12;
      } else if (period === "AM" && hours === 12) {
        hour24 = 0;
      }

      return hour24 * 60 + minutes;
    }

    // Handle "16:24" format
    if (time.includes(":")) {
      const [hours, minutes] = time.split(":").map(Number);
      return hours * 60 + minutes;
    }
  }

  // Fallback to 0 if invalid format
  console.warn("Invalid time format:", time);
  return 0;
}

export function eventStartsBefore(eventA, eventB) {
  const startTimeA = timeStringToMinutes(eventA.startTime);
  const startTimeB = timeStringToMinutes(eventB.startTime);
  return startTimeA < startTimeB;
}

export function eventEndsBefore(eventA, eventB) {
  const endTimeA = timeStringToMinutes(eventA.endTime);
  const endTimeB = timeStringToMinutes(eventB.endTime);
  return endTimeA < endTimeB;
}

export function eventCollidesWith(eventA, eventB) {
  const startTimeA = timeStringToMinutes(eventA.startTime);
  const endTimeA = timeStringToMinutes(eventA.endTime);
  const startTimeB = timeStringToMinutes(eventB.startTime);
  const endTimeB = timeStringToMinutes(eventB.endTime);

  const maxStartTime = Math.max(startTimeA, startTimeB);
  const minEndTime = Math.min(endTimeA, endTimeB);

  return minEndTime > maxStartTime;
}

export function eventTimeToDate(event, eventTime) {
  let hours = 0, minutes = 0;

  if (typeof eventTime === "string") {
    // Handle "4:24 PM" format
    if (eventTime.includes("AM") || eventTime.includes("PM")) {
      const [timePart, period] = eventTime.split(" ");
      const [h, m] = timePart.split(":");
      hours = parseInt(h, 10);
      minutes = parseInt(m, 10);

      if (period === "PM" && hours !== 12) {
        hours += 12;
      } else if (period === "AM" && hours === 12) {
        hours = 0;
      }
    }
    // Handle "16:24" format
    else if (eventTime.includes(":")) {
      const [h, m] = eventTime.split(":");
      hours = parseInt(h, 10);
      minutes = parseInt(m, 10);
    }
  } else if (typeof eventTime === "number") {
    hours = Math.floor(eventTime / 60);
    minutes = eventTime % 60;
  }

  return new Date(
    event.date.getFullYear(),
    event.date.getMonth(),
    event.date.getDate(),
    hours,
    minutes
  );
}

export function validateEvent(event) {
  const startTimeMinutes = timeStringToMinutes(event.startTime);
  const endTimeMinutes = timeStringToMinutes(event.endTime);

  if (startTimeMinutes >= endTimeMinutes) {
    return "Event end time must be after start time";
  }

  return null;
}

export function adjustDynamicEventMaxLines(dynamicEventElement) {
  const availableHeight = dynamicEventElement.offsetHeight;
  const lineHeight = 16;
  const padding = 8;
  const maxTitleLines = Math.floor((availableHeight - lineHeight - padding) / lineHeight);

  dynamicEventElement.style.setProperty("--event-title-max-lines", maxTitleLines);
}

export function generateEventId() {
  return Date.now();
}

// Helper function for pixel-based positioning (alternative approach)
function getEventTop(startTime) {
  const startMinutes = timeStringToMinutes(startTime);
  const hourHeight = 60; // px per hour
  return (startMinutes / 60) * hourHeight;
}

export function renderEvent(parent, event) {
  const top = getEventTop(event.startTime) + "px";
  initDynamicEvent(parent, event, { top, left: "0", right: "0", bottom: "unset" });
}