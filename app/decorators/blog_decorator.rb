class BlogDecorator < ApplicationDecorator
  delegate_all

  def ready_to_publish_button
    return unless object.draft?

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
      h.concat(h.content_tag(:span, object.status.titleize, class: "nav-link #{status_class} font-weight-bold"))
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

  def status_class
    case status
      when object.class.statuses[:draft]
        'text-warning'
      else
        'text-light'
    end
  end

  def display_form_preview_image
    show = object.preview_image.attached?
    h.content_tag :div, class: "blog__display-preview-img-holder #{!show ? 'd-none' : 'mb-4'}" do
      h.capture do
        h.concat(
          h.link_to(purge_preview_image_url, class: 'form-group blog__preview-img-remove-icon text-decoration-none', data: { action: 'blogs-editable#removeFileForPreview' }) do
            h.content_tag(:span, "&times;".html_safe)
          end
        )
        h.concat(h.image_tag(show ? h.rails_blob_path(object.preview_image) : '', class: 'img-fluid'))
      end
    end
  end
  def purge_preview_image_url
    return '#' unless object.preview_image.attached?

    h.attachment_path(object.preview_image.id, format: :json)
  end
end