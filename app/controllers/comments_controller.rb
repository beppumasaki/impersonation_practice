class CommentsController < ApplicationController
    def create
        @comment = Comment.new(comment_params)
        @result = @comment.result
        if @comment.save
          redirect_to result_path(@result)
        else
          redirect_to results_path
        end
      end

      def destroy
        @comment = Comment.find(params[:id])
        @result = @comment.result
        @comment.destroy
        redirect_to result_path(@result)

      end
    
      private
      def comment_params
        params.require(:comment).permit(:body, :result_id, :user_id)
      end
end
