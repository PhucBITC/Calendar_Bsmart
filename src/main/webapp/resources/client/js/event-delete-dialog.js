import { initDialog } from "./dialog.js";

export function initEventDeleteDialog() {
  const dialog = initDialog("event-delete");

  const deleteButtonElement = dialog.dialogElement.querySelector("[data-event-delete-button]");

  let currentEvent = null;

  document.addEventListener("event-delete-request", (event) => {
    currentEvent = event.detail.event;
    fillEventDeleteDialog(dialog.dialogElement, event.detail.event);
    dialog.open();
  });

  deleteButtonElement.addEventListener("click", () => {
    const modeElement = dialog.dialogElement.querySelector('input[name="delete-mode"]:checked');
    const deleteMode = modeElement ? modeElement.value : 'single';

    dialog.close();
    deleteButtonElement.dispatchEvent(new CustomEvent("event-delete", {
      detail: {
        event: currentEvent,
        deleteMode: deleteMode
      },
      bubbles: true
    }));
  });
}

function fillEventDeleteDialog(parent, event) {
  const eventDeleteTitleElement = parent.querySelector("[data-event-delete-title]");
  eventDeleteTitleElement.textContent = `Do you want to delete the event"${event.title}"?`;

  // Tìm hoặc tạo container cho các tùy chọn xóa
  let optionsContainer = parent.querySelector(".delete-options-container");
  if (!optionsContainer) {
    optionsContainer = document.createElement("div");
    optionsContainer.className = "delete-options-container";
    optionsContainer.style.marginTop = "15px";
    optionsContainer.style.textAlign = "left";
    eventDeleteTitleElement.after(optionsContainer);
  }

  // Render options 
  optionsContainer.innerHTML = `
  <div style="margin-bottom: 8px;">
    <label style="display: flex; align-items: center; cursor: pointer;">
      <input type="radio" name="delete-mode" value="single" checked style="margin-right: 8px;">
      Delete only this event
    </label>
  </div>

  <div style="margin-bottom: 8px;">
    <label style="display: flex; align-items: center; cursor: pointer;">
      <input type="radio" name="delete-mode" value="daily" style="margin-right: 8px;">
      Delete daily events
    </label>
  </div>

  <div style="margin-bottom: 8px;">
    <label style="display: flex; align-items: center; cursor: pointer;">
      <input type="radio" name="delete-mode" value="weekly" style="margin-right: 8px;">
      Delete weekly events
    </label>
  </div>

  <div>
    <label style="display: flex; align-items: center; cursor: pointer;">
      <input type="radio" name="delete-mode" value="monthly" style="margin-right: 8px;">
      Delete monthly events
    </label>
  </div>
  
`;

}