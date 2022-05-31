class CommentsController < ApplicationController
    def create
        @comment = Comment.new(comment_params)
        @result = Result.find(@comment.result_id)
        if @comment.save
          redirect_to user_result_path(current_user, @result)
        else
          redirect_to user_results_path(current_user)
        end
      end

      def destroy
        @comment = Comment.find(params[:id])
        @result = Result.find(@comment.result_id)
        @comment.destroy
        redirect_to user_result_path(current_user, @result)

      end
    
      private
      def comment_params
        params.permit(:body, :result_id, :user_id)
      end
end
