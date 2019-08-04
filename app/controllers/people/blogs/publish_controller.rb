module People
  module Blogs
    class PublishController < ApplicationController
      before_action { @layout_header = false }
      before_action :set_blog,:set_publish_blog

      def new
        @publish_blog = Blog::PublishDecorator.decorate(Blog::Publish.new(@blog.as_json))
        @publish_blog.valid?
      end

      def schedule_for_later
        render layout: false
      end

      def create
        if publish_blog_params[:status] == Blog.statuses[:scheduled]
          @blog.schedule_for_later(publish_blog_params[:scheduled_at])
          flash[:notice] = I18n.t('blogs.publish.scheduled', { scheduled_at: @blog.scheduled_at.strftime('%d %B, %Y at %I:%M %P') })
        else
          @blog.published!
          flash[:notice] = I18n.t('blogs.publish.published')
        end

        redirect_to people_blogs_path
      end

      private

        def set_publish_blog
          @publish_blog = Blog::PublishDecorator.decorate(Blog::Publish.new(@blog.as_json))
        end

        def set_blog
          @blog = current_person.blogs.find(params[:blog_id]).decorate
        end

        def publish_blog_params
          params.permit(:status, :scheduled_at)
        end
    end
  end
end