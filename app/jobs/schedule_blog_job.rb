class ScheduleBlogJob < ApplicationJob
  queue_as :default

  def perform(blog_id)
    Blog.find(blog_id).published!
  end
end