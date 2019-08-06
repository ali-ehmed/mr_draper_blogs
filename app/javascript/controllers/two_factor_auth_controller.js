import { Controller } from "stimulus"
import Rails from "rails-ujs";

// Two-Factor Authentication controller
export default class extends Controller {
  // Element which opens the Require Auth Modal
  get sourceElement() {
    return document.querySelector('[data-require_auth_source]');
  }
  
  get twoFactorAuthModal() {
    return document.querySelector('.two-factor-auth-modal');
  }
  
  submitForm(e) {
    e.preventDefault();

    let el = e.currentTarget;
    Rails.ajax({
      type: el.method,
      url: el.action,
      data: $(el).serialize(),
      success: (data, status, xhr) => {
        if (data && data.errors) {
          el.querySelector('input[type="submit"]').disabled = false;
          this.displayErrors(data.errors);
        } else {
          this.verified();
        }
      }
    });
  }

  requestAuthToken(e) {
    let [data, status, xhr] = e.detail;
    if (data && data.errors)
      this.displayErrors(data.errors);
  }

  pollApprovalStatus() {
    let pollId;
    const pollRequest = () => {
      Rails.ajax({
        type: 'GET',
        url: '/two_factor_auth/onetouch_approval_status',
        success: (data, status, xhr) => {
          if (data.status === 'approved') {
            clearInterval(pollId);
            this.verified();
          } else {
            if (data.errors)
              this.displayErrors(data.errors);
          }
        }
      });
    };

    pollId = setInterval(pollRequest, 5000, 1);
  }
  
  verified() {
    $(this.twoFactorAuthModal).modal('hide');
    // Set data attribute to the source element so we can Return from requireAuth()
    this.sourceElement.dataset.require_auth_completed = 'true';
    this.submitSourceElement();
  }

  requireAuth(e) {
    let el = e.currentTarget;
    
    // Return when Require 2AF is completed
    if (el.dataset.require_auth_completed === 'true') {
      return
    }
    
    e.preventDefault();

    // Set data attribute to the element which opens the Require Auth Modal, so we can get this source element
    // later from the this data attribute.
    // Remove data attributes first as these attrs will be set only on one Source Elem at a time.
    this.removeDataAttributesFromSourceElem();
    el.dataset.require_auth_source = 'true';

    Rails.ajax({
      type: 'GET',
      url: '/two_factor_auth/new',
      success: (data, status, xhr) => {
        $('body').append(xhr.responseText);

        let twoFactorAuthModal = this.twoFactorAuthModal;
        $(twoFactorAuthModal).modal('show');
        $(twoFactorAuthModal).on('hidden.bs.modal', function () {
          $(twoFactorAuthModal).remove();
        });
      }
    });
  }
  
  submitSourceElement() {
    if (this.sourceElement.tagName === 'form') {
      this.sourceElement.submit();
    } else {
      this.sourceElement.click();
    }
  }
  
  displayErrors(errors) {
    let errorsElement = this.twoFactorAuthModal.querySelector('.two-factor-auth-modal__errors');
    errorsElement.classList.remove('d-none');
    errorsElement.innerHTML = errors;

    // Hide Errors after 1500 seconds
    setTimeout(() => {
      this.hideErrors();
    }, 2000)
  }
  
  hideErrors() {
    let errorsElement = this.twoFactorAuthModal.querySelector('.two-factor-auth-modal__errors');
    errorsElement.classList.add('d-none');
    errorsElement.innerHTML = "";
  }
  
  removeDataAttributesFromSourceElem() {
    if (this.sourceElement)
      this.sourceElement.removeAttribute('data-require_auth_source');
    if (this.sourceElement)
      this.sourceElement.removeAttribute('data-require_auth_completed');
    }
}
