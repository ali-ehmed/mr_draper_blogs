# Twilio Authy Service
#
module Authy
  class TwoFactorAuthError < StandardError; end

  class TwoFactorAuth
    VIA = {
      sms:        :request_sms,
      phone_call: :request_phone_call,
      onetouch:   :onetouch_verification_request
    }.freeze

    attr_accessor :person, :authy_id, :token, :via, :errors
    alias_method :errors?, :errors

    def initialize(person, token: nil, via: nil)
      @person   = person
      @via      = via
      @authy_id = person.authy_id
      @token    = token
    end

    def verified?
      raise Authy::TwoFactorAuthError, "Auth request verification token can't be blank" if token.nil?

      response = Authy::API.verify(id: authy_id, token: token)

      self.errors = response.errors['message'] unless response.ok?

      response.ok?
    end

    def request_auth_token
      raise Authy::TwoFactorAuthError, 'You cannot request Auth without passing any method' if via.nil?

      __send__(VIA[via.to_sym])
    end

    # Crate dynamic methods of request_sms and request_phone, as both carries the common code
    [VIA[:sms], VIA[:phone_call]].each do |via|
      define_method via do
        response = Authy::API.__send__(via.to_s, id: authy_id, force: true)

        self.errors = response.errors['message'] unless response.ok?
      end
    end

    def onetouch_verification_request
      one_touch = Authy::OneTouch.send_approval_request(
        id: person.authy_id,
        message: 'Login requested for Account Security account.',
        details: {
          'Name':           person.name,
          'Email Address':  person.email,
          'Username':       person.username,
          'Country Code':   person.country_code,
          'Cell Phone':     person.cellphone
        }
      )

      if one_touch.ok?
        person.last_authy_approval_uuid = one_touch['approval_request']['uuid']
        person.save(validate: false)
      else
        self.errors = one_touch.errors['message']
      end
    end

    def onetouch_approval_status
      status = Authy::OneTouch.approval_request_status(uuid: person.last_authy_approval_uuid)

      raise Authy::TwoFactorAuthError, status.errors['message'] unless status.ok?

      status['approval_request']['status']
    end
  end
end