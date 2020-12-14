import flatpickr from 'flatpickr'
import { Russian } from "flatpickr/dist/l10n/ru.js"
require('flatpickr/dist/flatpickr.css')



document.addEventListener("turbolinks:load", () => {
  flatpickr("[class='flatpickr']", {
    altInput: true,
    mode: 'range',
    // altFormat: "F j, Y",
    altFormat: "d/m/y",
    dateFormat: "Y-m-d",
    locale: Russian
  })
})


document.addEventListener("turbolinks:load", () => {
  flatpickr("[class='datepicker']", {
    altInput: true,
    altFormat: "F j, Y",
    dateFormat: "Y-m-d",
    locale: Russian
  })
})
