document.addEventListener("DOMContentLoaded", () => {
    const buttons = document.querySelectorAll("[data-color]");
    const root = document.documentElement;

    // ローカルストレージから色を復元
    const savedColor = localStorage.getItem("main-color");
    if (savedColor) {
        root.style.setProperty("--main-color", savedColor);
    }

    // ボタンをクリックしたらテーマ変更
    buttons.forEach((btn) => {
        btn.addEventListener("click", () => {
            const color = btn.getAttribute("data-color");
            root.style.setProperty("--main-color", color);
            localStorage.setItem("main-color", color);
        });
    });
});