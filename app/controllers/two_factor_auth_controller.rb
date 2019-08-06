class TwoFactorAuthController < ApplicationController
  def new
    render layout: false
  end

  # Verifies the token submitted from Form
  def verify
    authy = Authy::TwoFactorAuth.new(current_person, token: params[:token])

    if authy.verified?
      head :ok
    else
      render json: { errors: authy.errors }
    end
  rescue Authy::TwoFactorAuthError => e
    render json: { errors: e.message }
  end

  # Requests Authy API to send the Token to user's device via SMS, Phone Call or OneTouch
  def request_auth_token
    authy = Authy::TwoFactorAuth.new(current_person, via: params[:via])
    authy.request_auth_token

    if authy.errors?
      render json: { errors: authy.errors? }
    else
      head :ok
    end
  rescue Authy::TwoFactorAuthError => e
    render json: { errors: e.message }
  end

  # This action is hit through polling, as polling is the recommended way by Authy API to check the Push Authentication approval status
  def onetouch_approval_status
    authy = Authy::TwoFactorAuth.new(current_person)

    render json: { status: authy.onetouch_approval_status }
  rescue Authy::TwoFactorAuthError => e
    render json: { errors: e.message }
  end
end