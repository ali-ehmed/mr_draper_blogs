module ApplicationHelper
  def flash_messages_alerts
    %w(notice alert warning info)
  end

  def flash_alert_type(name)
    case name.to_s
      when 'notice'
        'success'
      when 'warning'
        'warning'
      when 'info'
        'info'
      else
        'danger'
    end
  end

  def form_group_error(object, attribute)
    object.errors[attribute].present? ? 'has-error' : ''
  end

  def form_group_error_message(object, attribute)
    content_tag(:div, "#{attribute.to_s.humanize} #{object.errors.messages[attribute].uniq.to_sentence}", class: 'invalid-feedback') if object.errors[attribute].present?
  end

  def form_input_error(object, attribute)
    'is-invalid' if object.errors[attribute].present?
  end
end
