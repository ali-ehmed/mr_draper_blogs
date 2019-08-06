import { Controller } from "stimulus"

// Toggle Sign Up/Sign In tabs in  Sign up form modal
export default class extends Controller {
  connect() {
    this.element.addEventListener('click', (e) => {
      e.preventDefault();
      let tabName = this.data.get('tab-name');
      if (tabName) {
        let tab = document.querySelector(`.sign-in-modal__nav li a[href='#${tabName}']`);
        $(tab).tab('show');
      }
    })
  }
}
