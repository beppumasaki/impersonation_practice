class CollaborationCommentsController < ApplicationController
  def create
    @collaboration_comment = CollaborationComment.new(collaboration_comment_params)
    @collaboration = @collaboration_comment.collaboration
    if @collaboration_comment.save
      redirect_to collaboration_path(@collaboration)
    else
      redirect_to collaborations_path
    end
  end

  def destroy
    @collaboration_comment = CollaborationComment.find(params[:id])
    @collaboration = Collaboration.find(@collaboration_comment.collaboration_id)
    @result = Result.find(@collaboration.result_id)
    @collaboration_comment.destroy
    redirect_to collaboration_path(@collaboration)

  end

  private
  def collaboration_comment_params
    params.require(:collaboration_comment).permit(:body, :collaboration_id, :user_id)
  end
end
