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