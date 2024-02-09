document.addEventListener('turbolinks:load', (event) => {
    document.querySelectorAll(".collapsible").forEach((collapsible, index) => {
        let controls = collapsible.querySelector(".collapsible__header");
        let content = collapsible.querySelector(".collapsible__content");
        let key = `collapsible_${collapsible.id}`;

        const open = () => {
            controls.setAttribute("aria-expanded", "true");
            content.style.display = "block";
            window.localStorage.setItem(key, true);
        };

        const close = () => {
            controls.setAttribute("aria-expanded", "false");
            content.style.display = "none";
            window.localStorage.setItem(key, false);
        };

        window.localStorage.getItem(key) === "true" && open()
        window.localStorage.getItem(key) === "false" && close()

        controls.addEventListener("click", e => {
            e.preventDefault();
            controls.getAttribute("aria-expanded") === "false" ? open() : close()

        });
    });
});
