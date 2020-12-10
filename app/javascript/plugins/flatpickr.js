import flatpickr from 'flatpickr'
require('flatpickr/dist/flatpickr.css')

document.addEventListener("turbolinks:load", () => {
  flatpickr("[class='flatpickr']", {
    altInput: true,
    mode: 'range',
    altFormat: "F j, Y",
    dateFormat: "Y-m-d",
  })
})
