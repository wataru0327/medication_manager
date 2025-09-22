document.addEventListener("turbo:load", () => {
  document.querySelectorAll(".remove-item").forEach((btn) => {
    btn.addEventListener("click", (e) => {
      e.preventDefault();
      const row = btn.closest(".prescription-item");
      row.querySelector(".destroy-flag").value = "1"; // 削除フラグを立てる
      row.style.display = "none"; // 即座に非表示
    });
  });
});
