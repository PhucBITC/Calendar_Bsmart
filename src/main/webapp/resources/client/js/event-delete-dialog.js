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
  eventDeleteTitleElement.textContent = `Bạn có muốn xóa sự kiện "${event.title}"?`;

  // Tìm hoặc tạo container cho các tùy chọn xóa
  let optionsContainer = parent.querySelector(".delete-options-container");
  if (!optionsContainer) {
    optionsContainer = document.createElement("div");
    optionsContainer.className = "delete-options-container";
    optionsContainer.style.marginTop = "15px";
    optionsContainer.style.textAlign = "left";
    eventDeleteTitleElement.after(optionsContainer);
  }

  // Render các tùy chọn
  optionsContainer.innerHTML = `
    <div style="margin-bottom: 8px;">
      <label style="display: flex; align-items: center; cursor: pointer;"><input type="radio" name="delete-mode" value="single" checked style="margin-right: 8px;"> Chỉ xóa sự kiện này</label>
    </div>
    <div style="margin-bottom: 8px;">
      <label style="display: flex; align-items: center; cursor: pointer;"><input type="radio" name="delete-mode" value="weekly" style="margin-right: 8px;"> Xóa các sự kiện này theo tuần</label>
    </div>
    <div>
      <label style="display: flex; align-items: center; cursor: pointer;"><input type="radio" name="delete-mode" value="monthly" style="margin-right: 8px;"> Xóa các sự kiện này theo tháng</label>
    </div>
  `;
}