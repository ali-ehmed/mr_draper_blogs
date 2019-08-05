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
      respond_to do |format|
        if @blog.save
          format.html { redirect_to edit_people_blog_path(@blog.id) }
          format.json { render json: { redirect: edit_people_blog_path(@blog.id) } }
        end
      end
    end

    def update
      respond_to do |format|
        if @blog.update(blog_params)
          format.html { redirect_to edit_people_blog_path(@blog.id) }
          format.json { head :ok }
        end
      end
    end

    def destroy
      @blog.destroy
      redirect_to people_blogs_path, alert: "#{@blog.after_destroy_title} Blog has be deleted."
    end

    private

      def set_blog
        @blog = current_person.blogs.find(params[:id]).decorate
      end

      def blog_params
        params.require(:blog).permit(:title, :short_description, :main_content, :preview_image)
      end
  end
end