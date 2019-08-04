module People
  class BlogsController < ApplicationController
    before_action :set_blog, only: %i[show edit update destroy]
    respond_to :js, only: %i[create update]

    def index
      @drafts     = current_person.blogs.draft.latest
      @scheduled  = current_person.blogs.scheduled.latest
      @published  = current_person.blogs.published.latest
    end

    def new
      @blog = current_person.blogs.build.decorate
    end

    def create
      @blog = current_person.blogs.build(blog_params)
      redirect_to edit_people_blog_path(@blog.id) if @blog.save
    end

    def update
      redirect_to edit_people_blog_path(@blog.id) if @blog.update_attributes(blog_params)
    end

    def destroy
      @blog.destroy
      redirect_to people_blogs_path, alert: "#{@blog.after_destroy_title} has be deleted."
    end

    private

      def set_blog
        @blog = current_person.blogs.find(params[:id]).decorate
      end

      def blog_params
        params.require(:blog).permit(:title, :short_description, :main_content)
      end
  end
end