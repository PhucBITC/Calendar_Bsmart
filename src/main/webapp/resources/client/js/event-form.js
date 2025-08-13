import { validateEvent, generateEventId } from "./event.js";

export function initEventForm(toaster) {
  const formElement = document.querySelector("[data-event-form]");

  let mode = "create";

  formElement.addEventListener("submit", (e) => {
    // Chặn submit tạm để validate
    e.preventDefault();

    const formEvent = formIntoEvent(formElement);
    const validationError = validateEvent(formEvent);
    if (validationError !== null) {
      toaster.error(validationError);
      return;
    }

    // Cập nhật UI
    if (mode === "create") {
      formElement.dispatchEvent(
        new CustomEvent("event-create", {
          detail: { event: formEvent },
          bubbles: true
        })
      );
    } else if (mode === "edit") {
      formElement.dispatchEvent(
        new CustomEvent("event-edit", {
          detail: { event: formEvent },
          bubbles: true
        })
      );
    }

    // Sau khi validate và cập nhật UI → submit thật để lưu DB
    formElement.submit();
  });

  return {
    formElement,
    switchToCreateMode(date, startTime, endTime) {
      mode = "create";
      fillFormWithDate(formElement, date, startTime, endTime);
    },
    switchToEditMode(event) {
      mode = "edit";
      fillFormWithEvent(formElement, event);
    },
    reset() {
      formElement.querySelector("#id").value = null;
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
  formElement.querySelector("#id").value = event.id;
  formElement.querySelector("#title").value = event.description; // đổi từ title -> description
  formElement.querySelector("#date").value = event.date.toISOString().substr(0, 10);
  formElement.querySelector("#start-time").value = event.startTime;
  formElement.querySelector("#end-time").value = event.endTime;
  const colorInput = formElement.querySelector(`[value='${event.color}']`);
  if (colorInput) colorInput.checked = true;
}
function formIntoEvent(formElement) {
  const formData = new FormData(formElement);
  const id = formData.get("id");
  const title = formData.get("description"); // đổi lại
  const date = formData.get("dayOfWeek"); // đổi lại
  const startTime = formData.get("startTime"); // đổi lại
  const endTime = formData.get("endTime"); // đổi lại
  const color = formData.get("color");

  return {
    id: id ? Number.parseInt(id, 10) : generateEventId(),
    title,
    date: new Date(date),
    startTime: startTime,
    endTime: endTime,
    color
  };
}

