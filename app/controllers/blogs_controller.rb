class BlogsController < ApplicationController
  respond_to :json, only: :index

  def index
    @blogs = Blog.published.includes(:author).search(params[:q])
  end

  def show
    @blog = Blog.ready_to_publish_or_published.find(params[:id]).decorate
  end
end