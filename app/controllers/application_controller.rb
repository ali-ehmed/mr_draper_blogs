class ApplicationController < ActionController::Base
  # Callbacks
  #
  before_action :configure_permitted_parameters, if: :devise_controller?

  # Class Methods
  #

  # Instance Methods
  #

  protected

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    request.referrer || root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name])
  end

  private
end
