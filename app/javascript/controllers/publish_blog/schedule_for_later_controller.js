import { Controller } from "stimulus";

export default class extends Controller {
  get scheduleFormWrapper() {
    return document.querySelector('.publish-blog__schedule-form-wrapper');
  }
  
  get publishFormWrapper() {
    return document.querySelector('.publish-blog__form-wrapper');
  }

  renderForm(e) {
    let [data, status, xhr] = e.detail;
    this.scheduleFormWrapper.innerHTML = xhr.responseText;
  
    this.publishFormWrapper.classList.add('d-none');
    this.scheduleFormWrapper.classList.remove('d-none');
  }
  
  closeForm(e) {
    e.preventDefault();
    this.publishFormWrapper.classList.remove('d-none');
    this.scheduleFormWrapper.classList.add('d-none');
  }
}
