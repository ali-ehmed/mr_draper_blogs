module People
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    def self.provide_callback_for(provider)
      define_method provider do
        person = Person.from_omniauth(request.env['omniauth.auth'])
        if person.valid? && person.persisted?
          set_flash_message(:notice, :success, kind: provider.to_s.titleize) if is_navigational_format?
          sign_in_and_redirect person, event: :authentication # This will throw if @person is not activated
        else
          redirect_to root_path, alert: I18n.t('devise.omniauth_callbacks.failure' % { kind: provider.to_s.titleize })
        end
      end
    end

    %i[facebook google_oauth2].each(&method(:provide_callback_for))

    def failure
      redirect_to root_path, alert: 'There was a problem signing you in. Please try signing in later.'
    end
  end
end