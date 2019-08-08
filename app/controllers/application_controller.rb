class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: -> { handle_http_exception(:not_found) }

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

  def handle_http_exception(status = :not_found, message = 'Resource Not Found', js_partial: nil)
    respond_to do |format|
      format.html do
        redirect_to root_path, alert: message
      end
      format.json { render json: { message: message, status: status }, status: status }
    end
  end

  def current_ability
    @current_ability ||= Ability.new(current_person)
  end

  protected

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
