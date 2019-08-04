class BlogDecorator < ApplicationDecorator
  delegate_all

  def ready_to_publish_button()
    tooltip_options = {}
    url             = '#'
    if object.persisted?
      url = h.new_people_blog_publish_path(id)
    else
      tooltip_options = { data: { toggle: 'tooltip', placement: 'bottom', title: 'Publishing will become available after you start writing.' } }
    end
    h.link_to 'Ready to Publish?', url, class: 'dropdown-item font-size-1', **tooltip_options
  end

  def blog_editable_statuses
    h.capture do
      h.concat(h.content_tag(:span, 'Draft', class: 'nav-link text-warning font-weight-bold'))
      if object.persisted?
        h.concat(h.content_tag(:span, '|', class: 'nav-link'))
        h.concat(h.content_tag(:span, 'Saved', class: 'nav-link text-light'))
      end
    end
  end

  def after_destroy_title
    return object.title if object.title.present?

    if object.draft?
      'Draft Blog'
    else
      'Blog'
    end
  end
end