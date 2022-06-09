class CollaborationsController < ApplicationController
   skip_before_action :require_login, only: %i[show]
   before_action :set_collaboration, only: %i[show edit update destroy]
   before_action :user_check, only: %i[edit update destroy]
   before_action :set_result, only: %i[show edit]
    
    def new
      @collaboration = Collaboration.new(collaboration_params)
      @result = @collaboration.result
    end

    def show
      @target = @result.target
      @user = @collaboration.user
      @collaboration_user = @result.user
      @collaboration_comments = CollaborationComment.where(collaboration_id: @collaboration.id)
      @collaboration_comment = CollaborationComment.new
      redirect_to root_path if current_user != @user && @collaboration.not_published?
    end

    def index
      @collaborations = current_user.collaborations
    end

    def edit
      @user = @collaboration.user
      @target = @result.target
      @collaboration_user = @result.user
    end
  
    def destroy
      @collaboration.destroy
      redirect_to collaborations_path
    end
  
    def update
      @collaboration.update(update_collaboration_params)
      redirect_to collaborations_path
    end
  

    def create
      @collaboration = Collaboration.new(collaboration_params)
      @result = Result.find(params[:result_id])
      @collaboration.title = "#{current_user.name}と#{@result.user.name}"
      @collaboration.save

      render json: { url: collaboration_path(@collaboration) }
    end

    private

    def set_collaboration
      @collaboration = Collaboration.find(params[:id])
    end

    def set_result
      @result = @collaboration.result
    end

    def collaboration_params
      params.permit(:result_id, :user_id, :collaboration_voice)
    end

    def update_collaboration_params
      params.require(:collaboration).permit(:title, :body, :state)
    end

    def user_check
      @user = @collaboration.user
      redirect_to root_path if current_user != @user
    end
end
