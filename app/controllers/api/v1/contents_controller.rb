module Api
  module V1    
    class ContentsController < ApplicationController
      before_action :set_content, only: [:show, :update, :destroy]
      before_action :authenticate_user!

      def index
        @contents = Content.all

        render_all_contents
      end

      def show
        render_content
      end

      def create
        @content = Content.new(content_params)

        if @content.save
          render_content
        else
          render_error
        end
      end

      def update
        if @content.update(content_params)
          render_content
        else
          render_error
        end
      end

      def destroy
        if @content.destroy
          render_delete_message
        else
          render_error
        end
      end

      private

      def set_content
        @content = Content.find(params[:id])
      end

      def render_all_contents
        render json: @contents,
               each_serializer: ContentSerializer,
               adapter: :json_api
      end

      def render_content
        render json: @content,
               serializer: ContentSerializer,
               adapter: :json_api
      end

      def render_error
        render json: @content.errors,
               status: :unprocessable_entity
      end

      def render_delete_message
        render json: { message: 'Deleted' }
      end

      def content_params
        params.require(:content).permit(:title, :body)
      end
    end
  end
end
