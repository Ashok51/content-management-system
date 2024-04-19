module Api
  module V1    
    class ContentsController < ApplicationController
      before_action :set_content, only: [:show, :update, :destroy]

      def index
        @contents = Content.all
        render json: @contents,
               serializer: ContentSerializer,
               adapter: :json_api
      end

      def show
        render json: @content,
               serializer: ContentSerializer,
               adapter: :json_api
      end

      def create
        @content = Content.new(content_params)

        if @content.save
          render json: @content,
                 serializer: ContentSerializer,
                 adapter: :json_api
        else
          render json: @content.errors, status: :unprocessable_entity
        end
      end

      def update
        if @content.update(content_params)
          render json: @content,
                 serializer: ContentSerializer,
                 adapter: :json_api
        else
          render json: @content.errors, status: :unprocessable_entity
        end
      end

      def destroy
        if @content.destroy
          render json: { message: 'Deleted' }
        else
          render json: @content.errors, status: :unprocessable_entity
        end
      end

      private

      def set_content
        @content = Content.find(params[:id])
      end

      def content_params
        params.require(:content).permit(:title, :body)
      end
    end
  end
end
