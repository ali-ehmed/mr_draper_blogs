class Blog < ApplicationRecord
  # Concerns Macros
  #

  # Constants
  #

  # Association Macros
  #
  belongs_to :author, class_name: Person.name, foreign_key: :author_id
  has_one_attached :preview_image

  # Scope Macros
  #
  scope :latest, -> { order('created_at DESC') }
  scope :ready_to_publish_or_published, -> { where.not(status: statuses[:draft]) }

  # Attributes
  #
  enum status: { draft: 'draft', scheduled: 'scheduled', published: 'published' }

  # Delegates
  #

  # Validation Macros
  #
  # Validations are present in Blog::Publish

  # Callbacks
  #
  after_initialize do
    self.status = self.class.statuses[:draft] if new_record?
  end
  before_save :clear_main_content

  # Class Methods
  #
  def self.search(q)
    joins(:author).where('LOWER(title) ILIKE :q OR LOWER(people.name) ILIKE :q', { q: "%#{q&.downcase}%" })
  end

  # Instance Methods
  #
  def schedule_for_later(published_at)
    update(status: self.class.statuses[:scheduled], published_at: DateTime.parse(published_at))
    ScheduleBlogJob.set(wait_until: self.published_at).perform_later(id)
  end

  def publish
    update(status: self.class.statuses[:published], published_at: DateTime.now)
  end

  # Using rich editor in the form put an unnecessary HTML, when we clear the input.
  # We have to make sure that when user empties the input we set the `main_content` attr nil
  def clear_main_content
    if main_content.present?
      fragments = Nokogiri::HTML::DocumentFragment.parse(main_content)
      self.main_content = nil if fragments.children.children[0].name == 'br'
    end
  end

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
