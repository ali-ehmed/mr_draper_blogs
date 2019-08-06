class Person < ApplicationRecord
  # Concerns Macros
  #
  include Gravtastic

  # Constants
  #

  # Association Macros
  #
  has_many :blogs, foreign_key: :author_id

  # Scope Macros
  #

  # Attributes
  #
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[facebook google_oauth2]
  gravtastic

  # Delegates
  #

  # Validation Macros
  #
  validates_presence_of :name
  validates :username, presence: :true, uniqueness: { case_sensitive: false }

  # Callbacks
  #
  before_validation :create_username
  before_save :enable_authy

  # Class Methods
  #
  def self.from_omniauth(auth)
    user = find_or_initialize_by(uid: auth.uid, provider: auth.provider)
    user.name       = auth.info.name
    user.email      = (auth.info.email)
    user.password   = Devise.friendly_token[0, 20] if user.new_record?
    user.username   = (auth.info.nickname || user.generate_username_from_email)
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
  #
  def register_to_authy_provider
    authy = Authy::API.register_user(email: email, cellphone: cellphone, country_code: country_code)

    if authy.ok?
      self.authy_id = authy.id # this will give you the user authy id to store it in your database
    else
      authy.errors # this will return an error hash
    end
  end

  def create_username
    self.username = generate_username_from_email if username.blank?
  end

  def generate_username_from_email
    u = email.split('@').first
    u.gsub('.', '-')
  end

  def enable_authy
    self.authy_enabled = cellphone.present? || country_code.present?

    return unless authy_enabled?

    authy = Authy::API.register_user(email: email, cellphone: cellphone, country_code: country_code)

    if authy.ok?
      self.authy_id = authy.id
    else
      errors.add(:base, authy.errors)
    end
  end

  def authy_registered?
    authy_id.present?
  end

  protected

  private
end

# == Schema Information
#
# Table name: people
#
#  id                       :bigint(8)        not null, primary key
#  authy_enabled            :boolean          default(FALSE)
#  cellphone                :string
#  country_code             :string
#  email                    :string           default(""), not null
#  encrypted_password       :string           default(""), not null
#  last_authy_approval_uuid :string
#  last_sign_in_with_authy  :datetime
#  name                     :string
#  provider                 :string(50)       default(""), not null
#  remember_created_at      :datetime
#  reset_password_sent_at   :datetime
#  reset_password_token     :string
#  uid                      :string(500)      default(""), not null
#  username                 :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  authy_id                 :string
#
# Indexes
#
#  index_people_on_authy_id              (authy_id)
#  index_people_on_email                 (email) UNIQUE
#  index_people_on_reset_password_token  (reset_password_token) UNIQUE
#  index_people_on_username              (username) UNIQUE
#
