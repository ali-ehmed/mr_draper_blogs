class Blog::Publish < Blog
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

  # Delegates
  #

  # Validation Macros
  #
  validates_presence_of :title, :main_content
  validates :title, length: { minimum: 5, maximum: 80 }

  # Callbacks
  #

  # Class Methods
  #

  # Instance Methods
  #

  protected

  private
end