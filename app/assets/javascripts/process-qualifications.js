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
  document.getElementById('add-certification').addEventListener('click', function() {
    const container = document.getElementById('certifications-container');
    const index = container.children.length;

    const certificationSelect = `
      <div>
        <select name="employee[certifications][${index}][type]" class="form-control">
          <option value="">Select Certification</option>
          <option value="dbs">DBS check</option>
          <option value="first_aid">First aid training</option>
          <option value="food_hygiene">Food Hygiene Qualification</option>
          <option value="senco">SENCO training</option>
          <option value="senco_early_years">Early Years Level 3 SENCO</option>
          <option value="safeguarding">(Other Safeguarding) Safeguarding for all training</option>

          <!-- Add more options as needed -->
        </select>
        <input type="date" name="employee[certifications][${index}][date]" class="form-control">
      </div>`;

    container.insertAdjacentHTML('beforeend', certificationSelect);
  });
});