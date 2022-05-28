class CollaborationCommentsController < ApplicationController
  def create
    @collaboration_comment = CollaborationComment.new(collaboration_comment_params)
    @collaboration = Collaboration.find(@collaboration_comment.collaboration_id)
    @result = Result.find(@collaboration.result_id)
    if @collaboration_comment.save
      redirect_to user_result_collaboration_path(current_user, @result, @collaboration)
    else
      redirect_to user_result_collaborations_path(current_user, @result)
    end
  end

  def destroy
    @collaboration_comment = CollaborationComment.find(params[:id])
    @collaboration = Collaboration.find(@collaboration_comment.collaboration_id)
    @result = Result.find(@collaboration.result_id)
    @collaboration_comment.destroy
    redirect_to user_result_collaboration_path(current_user, @result, @collaboration)

  end

  private
  def collaboration_comment_params
    # params.require(:collaboration_comment).permit(:body)
    params.permit(:body, :collaboration_id, :user_id)
end
end
