import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

// Connects to data-controller="flatpickr"
export default class extends Controller {
  connect() {
    let startDateElement = document.querySelector(".start_travel_date")
    let endDateElement = document.querySelector(".end_travel_date")

    let startDatePicker = flatpickr(startDateElement, {
      dateFormat: "Y-m-d",
      enableTime: false,
      altInput: true,
      altFormat: "F j, Y",
      defaultDate: startDateElement.value
        ? startDateElement.value.split("T")[0]
        : null,
      disable: [
        function (date) {
          // Disable if the date is in the past and not today
          const today = new Date()
          return date < today && !isSameDay(date, today)
        },
      ],
      onChange: function (selectedDates, dateStr) {
        endDatePicker.set("minDate", dateStr)
      },
    })

    let endDatePicker = flatpickr(endDateElement, {
      dateFormat: "Y-m-d",
      enableTime: false,
      altInput: true,
      altFormat: "F j, Y",
      defaultDate: endDateElement.value
        ? endDateElement.value.split("T")[0]
        : null,
      disable: [
        function (date) {
          // Disable if the date is before the start date
          return date < startDatePicker.selectedDates[0]
        },
      ],
    })
  }
}

function isSameDay(date1, date2) {
  return (
    date1.getFullYear() === date2.getFullYear() &&
    date1.getMonth() === date2.getMonth() &&
    date1.getDate() === date2.getDate()
  )
}
