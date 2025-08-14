import { initToaster } from "./toaster.js";

export function initNotifications() {
  const toaster = initToaster(document.body);

  document.addEventListener("event-create", () => {
    toaster.success("Event has been created");
  });

  document.addEventListener("event-delete", () => {
    toaster.success("Event has been deleted");
  });

  document.addEventListener("event-edit", () => {
    toaster.success("Event has been edited");
  });

  // Browser Notification permission
  if ("Notification" in window && Notification.permission === "default") {
    try { Notification.requestPermission(); } catch (_) {}
  }

  // Simple sound via WebAudio API
  function playBeep() {
    try {
      const ctx = new (window.AudioContext || window.webkitAudioContext)();
      const o = ctx.createOscillator();
      const g = ctx.createGain();
      o.connect(g); g.connect(ctx.destination);
      o.type = "sine"; o.frequency.value = 880; g.gain.value = 0.05;
      o.start(); setTimeout(()=>{ o.stop(); ctx.close(); }, 300);
    } catch (_) {}
  }

  // Poll upcoming events every 60s and notify 5 minutes before start
  const NOTIFIED_KEY = "events_notified_map";
  function loadNotifiedMap() {
    try { return JSON.parse(localStorage.getItem(NOTIFIED_KEY)) || {}; } catch { return {}; }
  }
  function saveNotifiedMap(map) {
    try { localStorage.setItem(NOTIFIED_KEY, JSON.stringify(map)); } catch {}
  }

  function getEvents() {
    try {
      const raw = localStorage.getItem("events");
      if (!raw) return [];
      const arr = JSON.parse(raw);
      return arr.map(e => ({ ...e, date: new Date(e.date) }));
    } catch { return []; }
  }

  setInterval(() => {
    const now = new Date();
    const in5 = new Date(now.getTime() + 5 * 60 * 1000);
    const notified = loadNotifiedMap();

    for (const ev of getEvents()) {
      const start = toDateTime(ev.date, ev.startTime);
      if (!start) continue;
      const idKey = String(ev.id || `${ev.title}|${ev.startTime}|${ev.endTime}`);
      if (notified[idKey]) continue;
      if (start >= now && start <= in5) {
        const msg = `Sắp đến lịch: ${ev.title} (${ev.startTime})`;
        toaster.success(msg);
        if ("Notification" in window && Notification.permission === "granted") {
          try { new Notification("Nhắc lịch", { body: msg }); } catch {}
        }
        playBeep();
        notified[idKey] = Date.now();
      }
    }
    saveNotifiedMap(notified);
  }, 60000);

  function toDateTime(dateObj, hhmm) {
    if (!dateObj || !hhmm) return null;
    const [h, m] = String(hhmm).split(":").map(x => parseInt(x, 10));
    if (Number.isNaN(h) || Number.isNaN(m)) return null;
    const d = new Date(dateObj.getFullYear(), dateObj.getMonth(), dateObj.getDate(), h, m, 0, 0);
    return d;
  }
}