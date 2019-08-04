class Blog::PublishDecorator < ApplicationDecorator
  delegate_all

  def attribute_error_class(attribute)
    object.errors[attribute].present? ? 'publish-blog__invalid-attr' : ''
  end

  def attribute_error(attribute)
    if object.errors[attribute].present?
      h.content_tag(:small, "#{attribute.to_s.humanize} #{object.errors.messages[attribute].uniq.to_sentence}", class: 'font-size-1')
    end
  end
end