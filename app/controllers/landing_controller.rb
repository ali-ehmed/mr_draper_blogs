class LandingController < ApplicationController
  before_action { @layout_header = false }

  def show
    @blogs = Blog.includes(:author).published.latest.paginate(page: params[:page], per_page: 20)
  end
end