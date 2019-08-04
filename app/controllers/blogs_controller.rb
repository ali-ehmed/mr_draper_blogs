class BlogsController < ApplicationController
  def show
    @blog = Blog.published.find(params[:id])
  end
end