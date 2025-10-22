import { initDialog } from "./dialog.js";
import { initToaster } from "./toaster.js";

export function initSmartSchedule() {
  const dialog = initDialog("smart-schedule");
  const toaster = initToaster(dialog.dialogElement);

  const generateBtn = document.getElementById("generate-schedule-btn");
  const applyBtn = document.getElementById("apply-schedule-btn");
  const resultDiv = document.getElementById("smart-schedule-result");
  const suggestionsDiv = document.getElementById("schedule-suggestions");

  let generatedSchedules = [];

  // Set default deadline to today + 7 days
  const deadlineInput = document.getElementById("task-deadline");
  const nextWeek = new Date();
  nextWeek.setDate(nextWeek.getDate() + 7);
  deadlineInput.value = nextWeek.toISOString().split('T')[0];

  // Handle smart schedule button click
  document.addEventListener("smart-schedule-request", () => {
    dialog.open();

    // Re-initialize button after dialog opens
    setTimeout(() => {
      const generateBtn = document.getElementById("generate-schedule-btn");
      if (generateBtn) {
        console.log("Generate button found after dialog opens");
        generateBtn.style.cursor = "pointer";
        generateBtn.disabled = false;
      }
    }, 100);
  });

  // Handle generate schedule button click
  generateBtn.addEventListener("click", async () => {
    console.log("Generate button clicked!"); // Debug log

    // Lấy form data thủ công thay vì dùng FormData
    const formFields = dialog.dialogElement.querySelector(".form__fields");

    // Validate required fields
    const taskTitle = formFields.querySelector("#task-title").value;
    const taskDeadline = formFields.querySelector("#task-deadline").value;

    console.log("Form data:", { taskTitle, taskDeadline }); // Debug log

    if (!taskTitle || !taskDeadline) {
      toaster.error("Vui lòng nhập đầy đủ thông tin bắt buộc");
      return;
    }

    const params = {
      taskTitle: taskTitle,
      taskDescription: formFields.querySelector("#task-description").value,
      taskPriority: formFields.querySelector("#task-priority").value,
      taskDeadline: taskDeadline,
      estimatedDuration: parseInt(formFields.querySelector("#estimated-duration").value),
      repeatCount: parseInt(formFields.querySelector("#repeat-count").value),
      startHour: formFields.querySelector("#start-hour").value,
      endHour: formFields.querySelector("#end-hour").value,
      breakTime: parseInt(formFields.querySelector("#break-time").value),
      useEDF: true,  // Mặc định dùng EDF
      useGreedy: true  // Mặc định dùng Greedy
    };

    console.log("Sending params:", params); // Debug log

    try {
      generateBtn.disabled = true;
      generateBtn.textContent = "Đang sinh lịch...";

      console.log("Making API call..."); // Debug log
      const response = await fetch('/schedule/api/generate-task-schedule', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(params)
      });

      console.log("Response received:", response.status); // Debug log
      const result = await response.json();
      console.log("Result:", result); // Debug log

      if (result.success) {
        generatedSchedules = result.data || [];
        displaySuggestions(generatedSchedules);
        resultDiv.style.display = "block";
        applyBtn.style.display = "inline-block";
        toaster.success(`Đã sinh ${generatedSchedules.length} lịch trình!`);
      } else {
        toaster.error(result.message || "Lỗi khi sinh lịch");
      }

    } catch (error) {
      console.error("Generate schedule error:", error);
      toaster.error("Lỗi kết nối mạng: " + error.message);
    } finally {
      generateBtn.disabled = false;
      generateBtn.textContent = "Sinh lịch";
    }
  });

  // Handle apply all schedules button click
  applyBtn.addEventListener("click", async () => {
    if (generatedSchedules.length === 0) {
      toaster.error("Không có lịch trình để áp dụng");
      return;
    }

    try {
      applyBtn.disabled = true;
      applyBtn.textContent = "Đang áp dụng...";

      let successCount = 0;
      let errorCount = 0;

      for (const schedule of generatedSchedules) {
        try {
          // Tạo task trước
          const taskFormData = new FormData();
          taskFormData.append("title", schedule.taskTitle);
          taskFormData.append("description", schedule.taskDescription);
          taskFormData.append("priority", schedule.priority);
          taskFormData.append("deadline", schedule.deadline);
          taskFormData.append("estimatedDuration", schedule.estimatedDuration);

          const taskResponse = await fetch('/tasks/api/save', {
            method: 'POST',
            body: taskFormData
          });

          const taskResult = await taskResponse.json();

          if (taskResult.success) {
            // Sau đó tạo schedule
            const scheduleFormData = new FormData();
            scheduleFormData.append("description", schedule.taskTitle);
            scheduleFormData.append("dayOfWeek", schedule.dayOfWeek);
            scheduleFormData.append("startTime", schedule.startTime);
            scheduleFormData.append("endTime", schedule.endTime);
            scheduleFormData.append("color", getPriorityColor(schedule.priority));

            console.log("Creating schedule with data:", {
              description: schedule.taskTitle,
              dayOfWeek: schedule.dayOfWeek,
              startTime: schedule.startTime,
              endTime: schedule.endTime,
              color: getPriorityColor(schedule.priority)
            });

            console.log("FormData entries:");
            for (let [key, value] of scheduleFormData.entries()) {
              console.log(`  ${key}: ${value}`);
            }

            const scheduleResponse = await fetch('/schedule/api/save', {
              method: 'POST',
              body: scheduleFormData
            });

            const scheduleResult = await scheduleResponse.json();
            console.log("Schedule creation result:", scheduleResult);

            if (scheduleResult.success) {
              successCount++;
            } else {
              errorCount++;
            }
          } else {
            errorCount++;
          }
        } catch (error) {
          errorCount++;
        }
      }

      if (successCount > 0) {
        toaster.success(`Đã tạo thành công ${successCount} lịch trình!`);
        if (errorCount > 0) {
          toaster.error(`${errorCount} lịch trình bị lỗi`);
        }

        // Close dialog and refresh calendar
        dialog.close();

        // Force refresh calendar data
        setTimeout(() => {
          // Dispatch multiple events to ensure calendar updates
          document.dispatchEvent(new CustomEvent("events-change", { bubbles: true }));
          document.dispatchEvent(new CustomEvent("calendar-refresh", { bubbles: true }));

          // Also try to sync from server
          const eventStore = window.eventStore;
          if (eventStore && typeof eventStore.syncFromServer === 'function') {
            eventStore.syncFromServer();
          }

          // If still not visible, reload page after 2 seconds
          setTimeout(() => {
            console.log("Reloading page to show new schedules...");
            window.location.reload();
          }, 2000);
        }, 500);
      } else {
        toaster.error("Không thể tạo lịch trình nào");
      }

    } catch (error) {
      console.error("Apply schedules error:", error);
      toaster.error("Lỗi khi áp dụng lịch trình");
    } finally {
      applyBtn.disabled = false;
      applyBtn.textContent = "Áp dụng tất cả";
    }
  });

  // Reset dialog when closed
  dialog.dialogElement.addEventListener("close", () => {
    resultDiv.style.display = "none";
    applyBtn.style.display = "none";
    generatedSchedules = [];
  });
}

function displaySuggestions(schedules) {
  const suggestionsDiv = document.getElementById("schedule-suggestions");

  if (schedules.length === 0) {
    suggestionsDiv.innerHTML = `
      <div style="text-align: center; padding: 2rem; color: #64748b;">
        <p>Không thể sinh lịch trình phù hợp.</p>
        <p>Hãy kiểm tra lại thông tin nhập vào.</p>
      </div>
    `;
    return;
  }

  const html = schedules.map((schedule, index) => `
    <div style="border: 1px solid #e2e8f0; border-radius: 0.5rem; padding: 1rem; margin-bottom: 0.5rem; background: white;">
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
        <h4 style="margin: 0; color: #1e293b;">${schedule.taskTitle}</h4>
        <span style="padding: 0.25rem 0.5rem; border-radius: 0.25rem; font-size: 0.75rem; font-weight: 600; background: ${getPriorityColor(schedule.priority)}; color: white;">
          ${schedule.priority}
        </span>
      </div>
      <div style="font-size: 0.875rem; color: #64748b;">
        <div><strong>Thời gian:</strong> ${schedule.startTime} - ${schedule.endTime}</div>
        <div><strong>Ngày:</strong> ${schedule.dayOfWeek}</div>
        <div><strong>Thời lượng:</strong> ${schedule.estimatedDuration} phút</div>
        <div><strong>Deadline:</strong> ${schedule.deadline}</div>
        <div><strong>Thuật toán:</strong> ${schedule.algorithm}</div>
      </div>
    </div>
  `).join('');

  suggestionsDiv.innerHTML = html;
}

function getPriorityColor(priority) {
  switch (priority?.toUpperCase()) {
    case 'HIGH':
      return '#dc2626';
    case 'MEDIUM':
      return '#ea580c';
    case 'LOW':
      return '#16a34a';
    default:
      return '#2563eb';
  }
}
