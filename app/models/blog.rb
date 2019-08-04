class Blog < ApplicationRecord
  # Concerns Macros
  #

  # Constants
  #

  # Association Macros
  #
  belongs_to :author, class_name: Person.name, foreign_key: :author_id
  
  # Scope Macros
  #
  scope :latest, -> { order('created_at DESC') }

  # Attributes
  #
  enum status: { draft: 'draft', scheduled: 'scheduled', published: 'published' }

  # Delegates
  #

  # Validation Macros
  #

  # Callbacks
  #
  after_initialize do
    self.status = self.class.statuses[:draft] if new_record?
  end
  # Class Methods
  #

  # Instance Methods

  protected

  private
end

# == Schema Information
#
# Table name: blogs
#
#  id                :bigint(8)        not null, primary key
#  main_content      :text
#  published_at      :datetime
#  scheduled_at      :datetime
#  short_description :string
#  status            :enum             not null
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  author_id         :integer
#
# Indexes
#
#  index_blogs_on_author_id  (author_id)
#
