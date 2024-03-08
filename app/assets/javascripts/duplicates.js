document.addEventListener("turbolinks:load", () => {
  const employeeTypes = ["primary", "secondary"];
  const selectElements = employeeTypes.map((type) =>
    document.getElementById(`${type}_employee`)
  );
  const submitButton = document.querySelector('input[type="submit"]');
  const confirmCheckboxes = document.querySelectorAll(
    'input[name="confirm_choice"]'
  );

  function checkConditions() {
    const anyChecked = Array.from(confirmCheckboxes).some((radioButton) => {
      return radioButton.checked;
    });
    const equalSelectedValues =
      selectElements[0].value === selectElements[1].value;

    errors = 0;
    if (!anyChecked) {
      errors++;
    }
    if (equalSelectedValues) {
      errors++;
    }

    submitButton.disabled = errors > 0;
  }

  function updateUrl() {
    const primaryValue = selectElements[0].value;
    const secondaryValue = selectElements[1].value;

    if (primaryValue && secondaryValue) {
      const newUrl = `/admin/duplicates/${primaryValue}/${secondaryValue}`;
      window.location = newUrl;
    } else if (primaryValue) {
      const newUrl = `/admin/duplicates/${primaryValue}`;
      window.location = newUrl;
    }
  }

  employeeTypes.forEach((type, index) => {
    const textElements = document.querySelectorAll(`[data-${type}-employee]`);

    function getSelectText() {
      const selected = selectElements[index].selectedIndex;
      return selectElements[index].options[selected].text;
    }

    function updateEmployeeText() {
      textElements.forEach((employee) => {
        employee.textContent = getSelectText();
      });
    }

    updateEmployeeText();

    selectElements[index].addEventListener("change", (el) => {
      updateUrl();
      updateEmployeeText();
      checkConditions();
    });
  });

  confirmCheckboxes.forEach((radioButton) => {
    radioButton.addEventListener("change", checkConditions);
  });

  function createDefinitionList(data) {
    const ul = document.createElement("ul");
    ul.className = "diff-list";

    const fields = [
      "id",
      "forenames",
      "surname",
      "date_of_birth",
      "postal_code",
      "created_at",
      "updated_at",
    ];
    for (let key in data) {
      if (fields.find((f) => key === f)) {
        const li = document.createElement("li");
        li.className = "diff-list__item";

        const pstrong = document.createElement("p");
        const strong = document.createElement("strong");
        pstrong.appendChild(strong);
        const keyText = key.charAt(0).toUpperCase() + key.slice(1);
        strong.textContent = keyText.replaceAll("_", " ") + ":";

        const span = document.createElement("p");
        span.textContent = data[key] ? data[key] : "NULL";

        li.appendChild(pstrong);
        li.appendChild(span);

        ul.appendChild(li);
      }
    }

    return ul;
  }

  function setEmployeeData() {
    const targets = document.querySelectorAll(`[data-employee-id]`);
    targets.forEach(async (target) => {
      const employeeId = target.dataset.employeeId;
      const data = await getEmployeeData(employeeId);
      if (data) {
        const dl = createDefinitionList(data);
        target.appendChild(dl);
        // target.textContent = JSON.stringify(data, null, 2);
      } else {
        target.textContent = "Employee data could not be displayed";
      }
      console.log(employeeId);
    });
  }

  async function getEmployeeData(employeeId) {
    return fetch("/admin/employees/" + employeeId + ".json")
      .then((response) => response.json())
      .then((data) => {
        console.log(data);
        return data;
      })
      .catch((error) => {
        console.error("Error:", error);
      });
  }

  setEmployeeData();
  checkConditions();
});
