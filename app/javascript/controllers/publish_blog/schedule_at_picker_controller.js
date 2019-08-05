import { Controller } from "stimulus"
import flatpickr from "flatpickr";

export default class extends Controller {
  connect() {
    flatpickr(this.element, {
      enableTime: true,
      minDate: 'today',
      defaultDate: "today",
      time_24hr: false,
      dateFormat: "Y-m-d h:i K",
      minuteIncrement: '1'
    });
  }
}
