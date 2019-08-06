class ProfileController < ApplicationController
  def show
    @person = Person.find_by!(username: params[:username]).decorate
    @blogs  = @person.blogs.published.latest
  end
end