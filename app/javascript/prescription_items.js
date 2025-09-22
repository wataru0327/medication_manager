document.addEventListener("turbo:load", () => {
  // --- 処方薬削除処理 ---
  document.querySelectorAll(".remove-item").forEach((btn) => {
    btn.addEventListener("click", (e) => {
      e.preventDefault();
      const row = btn.closest(".prescription-item");
      row.querySelector(".destroy-flag").value = "1"; // 削除フラグを立てる
      row.style.display = "none"; // 即座に非表示
    });
  });

  // --- ユーザー番号入力 → 患者名・ID 自動補完 ---
  const numberInput = document.getElementById("patient_number");
  const nameInput   = document.getElementById("patient_name");
  const idInput     = document.getElementById("patient_id");

  if (numberInput) {
    numberInput.addEventListener("blur", () => {
      const num = numberInput.value;
      if (num.trim() === "") return;

      fetch(`/patients/find_by_number?number=${num}`)
        .then((response) => response.json())
        .then((data) => {
          if (data.error) {
            nameInput.value = "";
            idInput.value   = "";
            alert(data.error);
          } else {
            nameInput.value = data.name;
            idInput.value   = data.id;
          }
        })
        .catch((error) => {
          console.error("通信エラー:", error);
        });
    });
  }
});
