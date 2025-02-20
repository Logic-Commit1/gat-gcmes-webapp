import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

// Connects to data-controller="flatpickr"
export default class extends Controller {
  static targets = ["dateInput"]

  connect() {
    // Initialize table date input if it exists
    if (this.hasDateInputTarget) {
      flatpickr(this.dateInputTarget, {
        dateFormat: "Y-m-d",
        enableTime: false,
        altInput: true,
        altFormat: "F j, Y",
      })
    }

    // Initialize start/end date pickers if they exist
    let startDateElement = document.querySelector(".start_date")
    let endDateElement = document.querySelector(".end_date")

    if (startDateElement && endDateElement) {
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
}

function isSameDay(date1, date2) {
  return (
    date1.getFullYear() === date2.getFullYear() &&
    date1.getMonth() === date2.getMonth() &&
    date1.getDate() === date2.getDate()
  )
}
