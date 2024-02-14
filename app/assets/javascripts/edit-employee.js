document.addEventListener('turbolinks:load', (event) => {
  document.querySelectorAll('.remove-attribute').forEach(function(button) {
    button.addEventListener('click', function(event) {
      event.preventDefault();
      var section = this.dataset.section;
      console.log('Attempting to remove section:', section);
      var targetRow = document.querySelector(`tr[data-section="${section}"]`);
      if (targetRow) {
        targetRow.style.display = 'none';
        document.querySelector(`input[name='employee[remove_${section}]']`).value = 'true';
      } else {
        console.log('No target row found for section:', section);
      }
    });
  });
});

document.addEventListener('turbolinks:load', function() {
  document.getElementById('add-skill').addEventListener('click', function() {
    const container = document.getElementById('skills-container');
    const index = container.children.length;

    const skillSelect = `
      <div class="field">
        <select name="employee[skills][${index}][type]" class="form-control field__input">
          <option value="">Select skill</option>
          <option value="dbs">DBS check</option>
          <option value="first_aid">Paediatric First Aid training</option>
          <option value="food_hygiene">Food Hygiene Qualification</option>
          <option value="senco">SENCO training</option>
          <option value="senco_early_years">Early Years Level 3 SENCO</option>
          <option value="safeguarding">(Other Safeguarding) Safeguarding for all training</option>
        </select>
        <input type="date" name="employee[skills][${index}][date]" class="form-control field__input">
      </div>`;

    container.insertAdjacentHTML('beforeend', skillSelect);
  });
});


document.addEventListener('turbolinks:load', function() {
  var currentlyEmployedCheckbox = document.querySelector('.checkbox__input[name="employee[currently_employed]"]');
  var employedToDateField = document.querySelector('.field__input[name="employee[employed_to]"]');

  function toggleEmployedToDateField() {
    if (currentlyEmployedCheckbox.checked) {
      employedToDateField.value = '';
      employedToDateField.disabled = true;
    } else {
      employedToDateField.disabled = false;
    }
  }

  toggleEmployedToDateField();

  currentlyEmployedCheckbox.addEventListener('change', toggleEmployedToDateField);
});
