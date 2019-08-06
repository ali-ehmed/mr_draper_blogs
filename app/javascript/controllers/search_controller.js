import { Controller } from "stimulus"
import '../../../vendor/assets/javascripts/jquery-flexdatalist/jquery.flexdatalist';
import Turbolinks from "turbolinks";

export default class extends Controller {
  connect() {
    const defaultOptions = {
      url: '/blogs',
      requestType: 'GET',
      keywordParamName: 'q',
      searchDelay: 400,
      searchIn: ["title", "author_name"],
      searchByWord: true,
      searchContain: true,
      template: (item, keyword) => {
        return `
          <div class="d-flex w-100 justify-content-between search-result-item">
            ${
              item.preview_image ? `<img src="${item.preview_image}" class="rounded mr-3" alt='blog-preview0image' />` : ``
            }
            <div class="w-100">
              <h5 class="border-bottom pb-2 mb-2 search-result-item__name item-name">${this.highlight(keyword, item.title)}</h5>
              <strong class="text-info">${item.author_name}</strong>
              <p class="mb-0">
                <span class="mr-1"><strong>Published At:</strong> ${item.published_at}</span>
              </p>
            </div>
          </div>`;
      }
    };
  
    let flexDatalist = $(this.element).flexdatalist({...this.options, ...defaultOptions});
  
    flexDatalist.on('select:flexdatalist', (event, item) => {
      Turbolinks.visit(item.view)
    });
  }
  
  highlight(keyword, text) {
    const regex = new RegExp(keyword, 'ig');
    return text.replace(regex, '<span class="highlight">$&</span>');
  }
}
