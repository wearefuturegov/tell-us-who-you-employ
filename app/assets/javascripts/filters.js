document.addEventListener("turbolinks:load", (event) => {
  let allFilters = document.querySelectorAll("[data-autosubmit]");
  console.log(allFilters);

  allFilters.forEach((filter) => {
    filter.addEventListener("change", () => {
      console.log(filter);
      filter.form.submit();
    });
  });
});
