function initPrescriptionForm() {
  const tableBody   = document.querySelector("#prescription-items-table tbody");
  const addButton   = document.getElementById("add-prescription-item");
  const numberInput = document.getElementById("patient_number");
  const nameInput   = document.getElementById("patient_name");
  const idInput     = document.getElementById("patient_id");

  if (!tableBody || !addButton) return;

  // --- 薬データをグローバルに埋め込む ---
  const medications = window.medications || [];

  // 追加ボタンをリセットしてイベントを一度だけ登録
  const newAddButton = addButton.cloneNode(true);
  addButton.parentNode.replaceChild(newAddButton, addButton);

  newAddButton.addEventListener("click", () => {
    const timestamp = new Date().getTime();
    const options = medications.map(m => `<option value="${m.id}">${m.name}</option>`).join("");

    const newRow = `
      <tr class="prescription-item">
        <td style="padding: 8px; width: 45%; border: 1px solid #ddd;">
          <select name="prescription[prescription_items_attributes][${timestamp}][medication_id]" style="width: 100%;">
            <option value="">薬を選択</option>${options}
          </select>
        </td>
        <td style="padding: 8px; width: 25%; border: 1px solid #ddd;">
          <input type="number" name="prescription[prescription_items_attributes][${timestamp}][days]" min="1" style="width:100%;">
        </td>
        <td style="padding: 8px; width: 30%; border: 1px solid #ddd; text-align:center;">
          <a href="#" class="remove-item">削除</a>
          <input type="hidden" class="destroy-flag" name="prescription[prescription_items_attributes][${timestamp}][_destroy]" value="false">
        </td>
      </tr>
    `;
    tableBody.insertAdjacentHTML("beforeend", newRow);
  });

  // --- 削除（委譲方式）---
  tableBody.addEventListener("click", (e) => {
    if (e.target.classList.contains("remove-item")) {
      e.preventDefault();
      const row = e.target.closest(".prescription-item");
      if (row) {
        row.querySelector(".destroy-flag").value = "1";
        row.style.display = "none";
      }
    }
  });

  // --- ユーザー番号入力 → 患者名自動入力 ---
  if (numberInput && nameInput && idInput) {
    const newNumberInput = numberInput.cloneNode(true);
    numberInput.parentNode.replaceChild(newNumberInput, numberInput);

    newNumberInput.addEventListener("blur", () => {
      const num = newNumberInput.value.trim();
      if (num === "") return;

      fetch(`/patients/find_by_number?number=${num}`)
        .then((res) => res.json())
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
        .catch((err) => console.error("通信エラー:", err));
    });
  }
}

// Turbo のイベントに登録
document.addEventListener("turbo:load", initPrescriptionForm);
document.addEventListener("turbo:render", initPrescriptionForm);












