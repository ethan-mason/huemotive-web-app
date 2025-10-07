document.addEventListener("DOMContentLoaded", () => {
    const modal = document.getElementById("taskModal");
    const openModalBtn = document.getElementById("openModalBtn");
    const closeModalBtn = document.getElementById("closeModalBtn");
    const cancelBtn = document.getElementById("cancelBtn");
    const body = document.body;
    const palette = document.getElementById("colorPalette");
    const roundedRange = document.getElementById("roundedRange");
    const root = document.documentElement;
  
    if (openModalBtn && modal) {
      openModalBtn.addEventListener("click", () => modal.classList.replace("hidden", "flex"));
      [closeModalBtn, cancelBtn].forEach(btn => btn?.addEventListener("click", () => modal.classList.add("hidden")));
      modal.addEventListener("click", e => { if (e.target === modal) modal.classList.add("hidden"); });
    }
  
    document.addEventListener("change", e => {
      if (e.target.classList.contains("task-checkbox")) {
        const label = e.target.closest('div').querySelector('label');
        label.classList.toggle("line-through", e.target.checked);
        label.classList.toggle("text-gray-400", e.target.checked);
      }
    });
  
    let currentColor = localStorage.getItem("main-color") || "#007bff";
    root.style.setProperty("--main", currentColor);
    body.style.background = gradientMood(currentColor);
  
    palette?.addEventListener("click", (e) => {
      const button = e.target.closest("button");
      if (!button) return;
      palette.querySelectorAll("button").forEach(b => b.classList.remove("ring-2", "ring-main", "ring-offset-2"));
      button.classList.add("ring-2", "ring-main", "ring-offset-2");
  
      currentColor = button.dataset.color;
      root.style.setProperty("--main", currentColor);
      body.style.background = gradientMood(currentColor);
      localStorage.setItem("main-color", currentColor);
    });
  
    roundedRange?.addEventListener("input", e => {
      root.style.setProperty("--rounded", `${e.target.value}px`);
    });
    root.style.setProperty("--rounded", `${roundedRange?.value || 8}px`);
  
    // === 🌀 Helper functions ===
    function gradientMood(hex) {
      const light = hexToRgba(hex, 0.02);
      const mid   = hexToRgba(hex, 0.03);
      const deep  = hexToRgba(hex, 0.04);
      return `radial-gradient(ellipse at top left, ${light}, ${mid}, ${deep})`;
    }
  
    function hexToRgba(hex, alpha) {
      const r = parseInt(hex.slice(1, 3), 16);
      const g = parseInt(hex.slice(3, 5), 16);
      const b = parseInt(hex.slice(5, 7), 16);
      return `rgba(${r}, ${g}, ${b}, ${alpha})`;
    }
  });