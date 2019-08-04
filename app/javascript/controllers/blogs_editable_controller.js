import { Controller } from "stimulus"
import MediumEditor from "medium-editor/dist/js/medium-editor.js";

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
          this.submitForm();
      })
    }
    // Use Custom Event of Medium Text Editor for Form Submission
    editor.subscribe('blur', (mouseEvent, editor) => {
      let value = editor.innerText;
      if (!!value)
        this.submitForm();
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

  submitForm() {
    this.element.querySelector('input[type="submit"]').click();
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
