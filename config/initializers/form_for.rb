# Removing field-with-errors class wrapper. As this was the default behavior of form_for tag.
ActionView::Base.field_error_proc = Proc.new do |html_tag, _|
  html_tag
end