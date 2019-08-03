class BlogsController < ApplicationController
  before_action :authenticate_person!, only: %i[new create edit update destroy]

  def new
    @blog = current_person.blogs.build
  end
end