import { Controller } from "stimulus"
import MediumEditor from "medium-editor/dist/js/medium-editor.js";
import Rails from "rails-ujs";
import Turbolinks from "turbolinks";

export default class extends Controller {
  static targets = ["titleInput", "shortDescriptionInput", "mainContentInput"];

  connect() {
    this.autoHeightOfMainContentInput();
    
    // Use Medium Editor as Rich Text Editor
    let editor = new MediumEditor(this.mainContentInputTarget, this.editorOptions);
    
    // Submit Form after user finish typing
    for(let input of [this.titleInputTarget, this.shortDescriptionInputTarget]) {
      input.addEventListener('blur', (e) => {
        let value = e.currentTarget.value;
        if (!!value)
          this.submitForm($(this.element).serialize());
      })
    }
    // Use Custom Event of Medium Text Editor for Form Submission
    editor.subscribe('blur', (mouseEvent, editor) => {
      let value = editor.innerText;
      if (!!value)
        this.submitForm($(this.element).serialize());
    });
  }
  
  // Increase height of Main Content textarea on Keyup, since it's a TextArea
  autoHeightOfMainContentInput() {
    this.mainContentInputTarget.addEventListener('keyup', (e) => {
      let el = e.currentTarget;
      el.style.height = "5px";
      el.style.height = (el.scrollHeight)+"px";
    });
  }

  submitForm(formData) {
    Rails.ajax({
      type: this.element.dataset.method,
      url: this.element.action,
      data: formData,
      success: (response) => {
        if (response && response.redirect)
          Turbolinks.visit(response.redirect);
      }
    });
  }

  browseFileForPreview(e) {
    e.preventDefault();
    document.querySelector('.blog__preview-img-file-input').click();
  }

  removeFileForPreview(e) {
    e.preventDefault();

    const clearPreview = () => {
      let fileInput                 = document.querySelector('.blog__preview-img-file-input');
      let displayPreviewImageHolder = document.querySelector('.blog__display-preview-img-holder');
      let imageTag                  = displayPreviewImageHolder.querySelector('img');

      fileInput.value = '';
      displayPreviewImageHolder.classList.add('d-none');
      $(imageTag).attr('src', e.target.result);
    };

    if (e.currentTarget.href.indexOf('#') <= 0) {
      Rails.ajax({
        type: 'DELETE',
        url: e.currentTarget.href,
        success: (data, status, xhr) => {
          clearPreview();
        }
      });
    } else {
      clearPreview();
    }
  }
  
  uploadPreviewImage() {
    let fileInput = document.querySelector('.blog__preview-img-file-input');
    let formData  = new FormData();
    formData.append("blog[preview_image]", fileInput.files[0]);
    this.submitForm(formData);
  }

  displayPreviewImage(e) {
    let input                     = e.srcElement;
    let displayPreviewImageHolder = document.querySelector('.blog__display-preview-img-holder');

    if (input.files && input.files[0]) {
      let reader = new FileReader();
    
      reader.onload = (e) => {
        displayPreviewImageHolder.classList.remove('d-none');
        let imageTag = displayPreviewImageHolder.querySelector('img');
        $(imageTag).attr('src', e.target.result);
      };
    
      reader.readAsDataURL(input.files[0]);
  
      // Upload Preview Image after Display
      this.uploadPreviewImage();
    }
  }

  get editorOptions() {
    return {
      placeholder: {
        text: 'Main Content'
      },
      toolbar: {
        buttons: [
          'bold',
          'italic',
          'underline',
          {
            name: 'h1',
            action: 'append-h2',
            aria: 'header type 1',
            tagNames: ['h2'],
            contentDefault: '<b>H1</b>',
            classList: ['custom-class-h1'],
            attrs: {
              'data-custom-attr': 'attr-value-h1'
            }
          },
          {
            name: 'h2',
            action: 'append-h3',
            aria: 'header type 2',
            tagNames: ['h3'],
            contentDefault: '<b>H2</b>',
            classList: ['custom-class-h2'],
            attrs: {
              'data-custom-attr': 'attr-value-h2'
            }
          },
          {
            name: 'h3',
            action: 'append-h4',
            aria: 'header type 3',
            tagNames: ['h4'],
            contentDefault: '<b>H3</b>',
            classList: ['custom-class-h4'],
            attrs: {
              'data-custom-attr': 'attr-value-h3'
            }
          },
          'justifyCenter',
          'quote',
          'anchor'
        ]
      }
    }
  }
}
