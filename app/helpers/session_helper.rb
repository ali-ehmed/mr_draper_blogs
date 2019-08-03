module SessionHelper
  def resource_name
    :person
  end

  def resource
    @resource ||= Person.new
  end

  def resource_class
    Person
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:person]
  end
  
  def render_registrations_layout(title)
    render layout: 'people/shared/registration_layout', locals: { title: title } do
      yield
    end
  end
end