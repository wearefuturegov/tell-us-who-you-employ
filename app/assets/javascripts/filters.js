document.addEventListener("turbolinks:load", (event) => {
  let allFilters = document.querySelectorAll("[data-autosubmit]");

  allFilters.forEach((filter) => {
    filter.addEventListener("change", () => {
      filter.form.submit();
    });
  });
});
