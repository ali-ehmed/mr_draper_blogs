class BlogsController < ApplicationController
  def show
    @blog = Blog.ready_to_publish_or_published.find(params[:id]).decorate
  end
end