import { generateWeekDays, isTheSameDay, today } from "./date.js";
import {
  isEventAllDay,
  eventStartsBefore,
  eventEndsBefore,
  initDynamicEvent,
  eventCollidesWith,
  adjustDynamicEventMaxLines
} from "./event.js";
import { initEventList } from "./event-list.js";

const calendarTemplateElement = document.querySelector("[data-template='week-calendar']");
const calendarDayOfWeekTemplateElement = document.querySelector("[data-template='week-calendar-day-of-week']");
const calendarAllDayListItemTemplateElement = document.querySelector("[data-template='week-calendar-all-day-list-item']");
const calendarColumnTemplateElement = document.querySelector("[data-template='week-calendar-column']");

const dateFormatter = new Intl.DateTimeFormat("en-US", {
  weekday: 'short'
});

// Helper function to convert time to minutes
function timeStringToMinutes(time) {
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

  console.warn("Invalid time format:", time);
  return 0;
}

export function initWeekCalendar(parent, selectedDate, eventStore, isSingleDay, deviceType) {
  const calendarContent = calendarTemplateElement.content.cloneNode(true);
  const calendarElement = calendarContent.querySelector("[data-week-calendar]");
  const calendarDayOfWeekListElement = calendarElement.querySelector("[data-week-calendar-day-of-week-list]");
  const calendarAllDayListElement = calendarElement.querySelector("[data-week-calendar-all-day-list]");
  const calendarColumnsElement = calendarElement.querySelector("[data-week-calendar-columns]");

  const weekDays = isSingleDay ? [selectedDate] : generateWeekDays(selectedDate);
  for (const weekDay of weekDays) {
    const events = eventStore.getEventsByDate(weekDay);
    const allDayEvents = events.filter((event) => isEventAllDay(event));
    const nonAllDayEvents = events.filter((event) => !isEventAllDay(event));

    sortEventsByTime(nonAllDayEvents);

    initDayOfWeek(calendarDayOfWeekListElement, selectedDate, weekDay, deviceType);

    if (deviceType === "desktop" || (deviceType === "mobile" && isTheSameDay(weekDay, selectedDate))) {
      initAllDayListItem(calendarAllDayListElement, allDayEvents);
      initColumn(calendarColumnsElement, weekDay, nonAllDayEvents);
    }
  }

  if (isSingleDay) {
    calendarElement.classList.add("week-calendar--day");
  }

  parent.appendChild(calendarElement);

  const dynamicEventElements = calendarElement.querySelectorAll("[data-event-dynamic]");

  for (const dynamicEventElement of dynamicEventElements) {
    adjustDynamicEventMaxLines(dynamicEventElement);
  }
}

function initDayOfWeek(parent, selectedDate, weekDay, deviceType) {
  const calendarDayOfWeekContent = calendarDayOfWeekTemplateElement.content.cloneNode(true);
  const calendarDayOfWeekElement = calendarDayOfWeekContent.querySelector("[data-week-calendar-day-of-week]");
  const calendarDayOfWeekButtonElement = calendarDayOfWeekElement.querySelector("[data-week-calendar-day-of-week-button]");
  const calendarDayOfWeekDayElement = calendarDayOfWeekElement.querySelector("[data-week-calendar-day-of-week-day]");
  const calendarDayOfWeekNumberElement = calendarDayOfWeekElement.querySelector("[data-week-calendar-day-of-week-number]");

  calendarDayOfWeekNumberElement.textContent = weekDay.getDate();
  calendarDayOfWeekDayElement.textContent = dateFormatter.format(weekDay);

  if (isTheSameDay(weekDay, today())) {
    calendarDayOfWeekButtonElement.classList.add("week-calendar__day-of-week-button--highlight");
  }

  if (isTheSameDay(weekDay, selectedDate)) {
    calendarDayOfWeekButtonElement.classList.add("week-calendar__day-of-week-button--selected");
  }

  calendarDayOfWeekButtonElement.addEventListener("click", () => {
    document.dispatchEvent(new CustomEvent("date-change", {
      detail: {
        date: weekDay
      },
      bubbles: true
    }));

    if (deviceType !== "mobile") {
      document.dispatchEvent(new CustomEvent("view-change", {
        detail: {
          view: "day"
        },
        bubbles: true
      }));
    }
  });

  parent.appendChild(calendarDayOfWeekElement);
}

function initAllDayListItem(parent, events) {
  const calendarAllDayListItemContent = calendarAllDayListItemTemplateElement.content.cloneNode(true);
  const calendarAllDayListItemElement = calendarAllDayListItemContent.querySelector("[data-week-calendar-all-day-list-item]");

  initEventList(calendarAllDayListItemElement, events);

  parent.appendChild(calendarAllDayListItemElement);
}

function initColumn(parent, weekDay, events) {
  const calendarColumnContent = calendarColumnTemplateElement.content.cloneNode(true);
  const calendarColumnElement = calendarColumnContent.querySelector("[data-week-calendar-column]");
  const calendarColumnCellElements = calendarColumnElement.querySelectorAll("[data-week-calendar-cell]");

  const eventsWithDynamicStyles = calculateEventsDynamicStyles(events);
  for (const eventWithDynamicStyles of eventsWithDynamicStyles) {
    initDynamicEvent(
      calendarColumnElement,
      eventWithDynamicStyles.event,
      eventWithDynamicStyles.styles
    );
  }

  for (const calendarColumnCellElement of calendarColumnCellElements) {
    const cellStartTime = Number.parseInt(
      calendarColumnCellElement.dataset.weekCalendarCell,
      10
    );
    const cellEndTime = cellStartTime + 60;

    calendarColumnCellElement.addEventListener("click", () => {
      document.dispatchEvent(new CustomEvent("event-create-request", {
        detail: {
          date: weekDay,
          startTime: cellStartTime,
          endTime: cellEndTime
        },
        bubbles: true
      }));
    });
  }

  parent.appendChild(calendarColumnElement);
}

function calculateEventsDynamicStyles(events) {
  console.log("=== CALCULATING EVENT POSITIONS ===");
  console.log("Total events:", events.length);

  const { eventGroups, totalColumns } = groupEvents(events);
  const columnWidth = 100 / totalColumns;
  const initialEventGroupItems = [];

  for (const eventGroup of eventGroups) {
    for (const eventGroupItem of eventGroup) {
      if (eventGroupItem.isInitial) {
        initialEventGroupItems.push(eventGroupItem);
      }
    }
  }

  return initialEventGroupItems.map((eventGroupItem, index) => {
    console.log(`--- Event ${index + 1} ---`);
    console.log("Event title:", eventGroupItem.event.title);
    console.log("Original start time:", eventGroupItem.event.startTime);
    console.log("Original end time:", eventGroupItem.event.endTime);

    // Convert time to minutes
    const startTimeInMinutes = timeStringToMinutes(eventGroupItem.event.startTime);
    const endTimeInMinutes = timeStringToMinutes(eventGroupItem.event.endTime);

    console.log("Start time in minutes:", startTimeInMinutes);
    console.log("End time in minutes:", endTimeInMinutes);
    // CẤU HÌNH: Chiều cao 1 ô giờ (bạn chỉnh số 60 này bằng đúng height trong CSS nhé)
    const pixelsPerHour = 60;
    const totalHeight = 24 * pixelsPerHour; // Tổng chiều cao lịch 24h

    // Tính vị trí theo Pixels
    const topPixels = (startTimeInMinutes / 60) * pixelsPerHour;

    // Tính chiều cao (height) thay vì bottom để tránh lỗi lệch do tổng chiều cao container không khớp
    const heightPixels = ((endTimeInMinutes - startTimeInMinutes) / 60) * pixelsPerHour;

    // Giữ nguyên tính toán chiều ngang (left/right) theo % vì nó chia cột
    const leftPercentage = columnWidth * eventGroupItem.columnIndex;
    const rightPercentage = columnWidth * (totalColumns - eventGroupItem.columnIndex - eventGroupItem.columnSpan);

    return {
      event: eventGroupItem.event,
      styles: {
        top: `${topPixels}px`,      // Dùng px
        height: `${heightPixels}px`, // Dùng px
        bottom: 'auto',              // Reset bottom để tránh xung đột CSS
        left: `${leftPercentage}%`,
        right: `${rightPercentage}%`
      }
    }
  });
}

function groupEvents(events) {
  if (events.length === 0) {
    return { eventGroups: [], totalColumns: 0 };
  }

  const firstEventGroup = [
    {
      event: events[0],
      columnIndex: 0,
      isInitial: true,
      eventIndex: 0
    }
  ];

  const eventGroups = [firstEventGroup];

  for (let i = 1; i < events.length; i += 1) {
    const lastEventGroup = eventGroups[eventGroups.length - 1];
    const loopEvent = events[i];

    const lastEventGroupCollidingItems = lastEventGroup.filter((eventGroupItem) => eventCollidesWith(eventGroupItem.event, loopEvent));

    if (lastEventGroupCollidingItems.length === 0) {
      const newEventGroupItem = {
        event: loopEvent,
        columnIndex: 0,
        isInitial: true,
        eventIndex: i
      };

      const newEventGroup = [newEventGroupItem];
      eventGroups.push(newEventGroup);
      continue;
    }

    if (lastEventGroupCollidingItems.length === lastEventGroup.length) {
      const newEventGroupItem = {
        event: loopEvent,
        columnIndex: lastEventGroup.length,
        isInitial: true,
        eventIndex: i
      };

      lastEventGroup.push(newEventGroupItem);
      continue;
    }

    let newColumnIndex = 0;
    while (true) {
      const isColumnIndexInUse = lastEventGroupCollidingItems.some((eventGroupItem) => eventGroupItem.columnIndex === newColumnIndex);

      if (isColumnIndexInUse) {
        newColumnIndex += 1;
      } else {
        break;
      }
    }

    const newEventGroupItem = {
      event: loopEvent,
      columnIndex: newColumnIndex,
      isInitial: true,
      eventIndex: i
    };

    const newEventGroup = [
      ...lastEventGroupCollidingItems.map((eventGroupItem) => ({
        ...eventGroupItem,
        isInitial: false
      })),
      newEventGroupItem
    ];

    eventGroups.push(newEventGroup);
  }

  let totalColumns = 0;
  for (const eventGroup of eventGroups) {
    for (const eventGroupItem of eventGroup) {
      totalColumns = Math.max(totalColumns, eventGroupItem.columnIndex + 1);
    }
  }

  for (const eventGroup of eventGroups) {
    eventGroup.sort((columnGroupItemA, columnGroupItemB) => {
      return columnGroupItemA.columnIndex < columnGroupItemB.columnIndex ? -1 : 1;
    });

    for (let i = 0; i < eventGroup.length; i += 1) {
      const loopEventGroupItem = eventGroup[i];
      if (i === eventGroup.length - 1) {
        loopEventGroupItem.columnSpan = totalColumns - loopEventGroupItem.columnIndex;
      } else {
        const nextLoopEventGroupItem = eventGroup[i + 1];
        loopEventGroupItem.columnSpan = nextLoopEventGroupItem.columnIndex - loopEventGroupItem.columnIndex;
      }
    }
  }

  for (let i = 0; i < events.length; i += 1) {
    let lowestColumnSpan = Infinity;

    for (const eventGroup of eventGroups) {
      for (const eventGroupItem of eventGroup) {
        if (eventGroupItem.eventIndex === i) {
          lowestColumnSpan = Math.min(lowestColumnSpan, eventGroupItem.columnSpan);
        }
      }
    }

    for (const eventGroup of eventGroups) {
      for (const eventGroupItem of eventGroup) {
        if (eventGroupItem.eventIndex === i) {
          eventGroupItem.columnSpan = lowestColumnSpan;
        }
      }
    }
  }

  return { eventGroups, totalColumns };
}

function sortEventsByTime(events) {
  events.sort((eventA, eventB) => {
    if (eventStartsBefore(eventA, eventB)) {
      return -1;
    }

    if (eventStartsBefore(eventB, eventA)) {
      return 1
    }

    return eventEndsBefore(eventA, eventB) ? 1 : -1;
  });
}