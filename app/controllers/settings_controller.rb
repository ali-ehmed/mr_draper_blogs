class SettingsController < ApplicationController
  before_action :authenticate_person!

  def update
    if current_person.update_without_password(profile_params)
      redirect_to profile_path(current_person.username, tab: params[:tab])
    else
      @person = current_person
      render 'profile/show'
    end
  end

  private

    def profile_params
      params.require(:person).permit(:name, :email, :password, :password_confirmation, :cellphone, :country_code)
    end
end