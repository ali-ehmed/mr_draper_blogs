import { Controller } from "stimulus"
import MediumEditor from "medium-editor/dist/js/medium-editor.js";

export default class extends Controller {
  static targets = ["titleInput", "shortDescriptionInput", "mainContentInput"];

  connect() {
    this.autoHeightOfMainContentInput();
    
    // Use Medium Editor as Rich Text Editor
    let editor = new MediumEditor(this.mainContentInputTarget, {
      placeholder: {
        text: 'Main Content'
      }
    });
    
    // Listen Auto Save Blog Callback and save blog post to Draft Status
    for(let input of [this.titleInputTarget, this.shortDescriptionInputTarget]) {
      input.addEventListener('keyup', this.autoSaveBlog)
    }
    // Use Custom Event of Medium Text Editor for listening the autoSaveBlog Callback
    editor.subscribe('editableInput', this.autoSaveBlog);
  }
  
  // Increase height of Main Content textarea on Keyup, since it's a TextArea
  autoHeightOfMainContentInput() {
    this.mainContentInputTarget.addEventListener('keyup', (e) => {
      let el = e.currentTarget;
      el.style.height = "5px";
      el.style.height = (el.scrollHeight)+"px";
    });
  }
  
  // Save Blog in Draft every time User leave the typing state
  autoSaveBlog(e, editable) {
    let value = undefined;
    if (e.constructor.name === 'InputEvent') {
      value = e.srcElement.innerText;
    } else {
      value = e.currentTarget.value;
    }
  }
}
