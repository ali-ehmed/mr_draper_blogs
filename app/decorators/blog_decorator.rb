class BlogDecorator < ApplicationDecorator
  delegate_all

  def ready_to_publish_button
    tooltip_options = {}
    unless object.persisted?
      tooltip_options = { data: { toggle: 'tooltip', placement: 'bottom', title: 'Publishing will become available after you start writing.' } }
    end
    h.link_to 'Ready to Publish?', '#', class: 'dropdown-item font-size-1', **tooltip_options
  end

  def blog_editable_statuses
    h.capture do
      h.concat(h.content_tag(:span, 'Draft', class: 'nav-link text-warning font-weight-bold'))
      h.concat(h.content_tag(:span, '|', class: 'nav-link'))
      h.concat(h.content_tag(:span, 'Saved', class: 'nav-link text-light'))
    end
  end
end