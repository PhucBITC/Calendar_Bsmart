export function initSmartScheduleButton() {
  const smartScheduleButton = document.querySelector("[data-smart-schedule-button]");
  
  if (smartScheduleButton) {
    smartScheduleButton.addEventListener("click", () => {
      document.dispatchEvent(new CustomEvent("smart-schedule-request", {
        bubbles: true
      }));
    });
  }
}
