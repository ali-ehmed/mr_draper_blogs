class Person < ApplicationRecord
  # Concerns Macros
  #

  # Constants
  #

  # Association Macros
  #

  # Scope Macros
  #

  # Attributes
  #
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook google_oauth2]

  # Delegates
  #

  # Validation Macros
  #
  validates_presence_of :name

  # Callbacks
  #

  # Class Methods
  #
  def self.from_omniauth(auth)
    user = find_or_initialize_by(uid: auth.uid, provider: auth.provider)
    user.name       = auth.info.name
    # user.username   = (auth.info.nickname || generate_oauth_username(auth.info)) # assuming the user model has a name
    user.email      = (auth.info.email)
    user.password   = Devise.friendly_token[0, 20] if user.new_record?
    # user.image      = auth.info.image # assuming the user model has an image
    # user.skip_confirmation! if user.new_record?
    user.save if user.changed? || user.new_record?

    user
  end

  # if we need to copy data from session whenever a user is initialized before sign up
  def self.new_with_session(params, session)
    super.tap do |user|
      provider      = session[:'devise.provider']
      provider_data = session[:"devise.#{provider}_data"]
      data = provider_data && provider_data['info']
      if data
        user.full_name = data['name']      if user.name.blank?
        user.email     = data['email']     if user.email.blank?
      end

      session[:'devise.provider'] = nil
    end
  end

  # Instance Methods

  protected

  private
end

# == Schema Information
#
# Table name: people
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string
#  provider               :string(50)       default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  uid                    :string(500)      default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_people_on_email                 (email) UNIQUE
#  index_people_on_reset_password_token  (reset_password_token) UNIQUE
#
