class ApplicationController < ActionController::Base
  # Helpers
  #

  # Callbacks
  #
  before_action :default_layout_components, :hide_layout_header_for_sign_in_and_sign_up_pages
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Class Methods
  #

  # Instance Methods
  #
  def default_layout_components
    @layout_header = true
    @layout_footer = true
  end

  def current_person
    PersonDecorator.decorate(super) unless super.nil?
  end

  protected

    # Overwriting the sign_out redirect path method
    def after_sign_out_path_for(resource_or_scope)
      request.referrer || root_path
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[name])
    end

    def hide_layout_header_for_sign_in_and_sign_up_pages
      return unless devise_controller?

      sign_in_and_sign_up_controller = params[:controller].in?(%w[devise/registrations devise/sessions]) && params[:action].in?(%w[new create])
      @layout_header, @layout_footer = !sign_in_and_sign_up_controller
    end

  private
end
