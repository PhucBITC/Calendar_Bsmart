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
      const response = await fetch('/task/api/generate-task-schedule', {
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

      const schedulesToApply = generatedSchedules.map(schedule => ({
        taskTitle: schedule.taskTitle,
        description: schedule.taskDescription,
        dayOfWeek: schedule.dayOfWeek,
        startTime: schedule.startTime,
        endTime: schedule.endTime,
        color: getPriorityColor(schedule.priority),
        deadline: schedule.deadline, // Thêm deadline
        estimatedDuration: schedule.estimatedDuration // Thêm thời lượng
      }));

      const response = await fetch('/task/api/apply-schedules', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(schedulesToApply)
      });

      const result = await response.json();

      if (result.success) {
        toaster.success(result.message || "Đã áp dụng lịch trình thành công!");
        dialog.close();
        // Refresh calendar
        setTimeout(() => {
          const eventStore = window.eventStore;
          if (eventStore && typeof eventStore.syncFromServer === 'function') {
            eventStore.syncFromServer();
          }
        }, 500);
      } else {
        toaster.error(result.message || "Không thể áp dụng lịch trình");
      }

    } catch (error) {
      console.error("Apply schedules error:", error);
      toaster.error("Lỗi khi áp dụng lịch trình: " + error.message);
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
        <div><strong>Thời gian:</strong> ${formatTime12Hour(schedule.startTime)} - ${formatTime12Hour(schedule.endTime)}</div>
        <div><strong>Ngày:</strong> ${schedule.dayOfWeek}</div>
        <div><strong>Thời lượng:</strong> ${schedule.estimatedDuration} phút</div>
        <div><strong>Deadline:</strong> ${schedule.deadline}</div>
        <div><strong>Thuật toán:</strong> ${schedule.algorithm}</div>
      </div>
    </div>
  `).join('');

  suggestionsDiv.innerHTML = html;
}

function formatTime12Hour(timeString) {
  if (!timeString) return '';
  const [hour, minute] = timeString.split(':');
  const hourInt = parseInt(hour, 10);
  const ampm = hourInt >= 12 ? 'PM' : 'AM';
  let hour12 = hourInt % 12;
  if (hour12 === 0) {
    hour12 = 12; // The hour '0' or '12' should be '12'
  }
  const hourStr = hour12 < 10 ? '0' + hour12 : hour12;
  return `${hourStr}:${minute} ${ampm}`;
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
