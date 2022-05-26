class CollaborationsController < ApplicationController
   skip_before_action :require_login, only: %i[show]
    
    def new
      @collaboration = Collaboration.new(collaboration_params)
      @result = Result.find(@collaboration.result_id)
    end

    def show
      @collaboration = Collaboration.find(params[:id])
      @result = Result.find(@collaboration.result_id)
      @target = Target.find(@result.target_id)
      @user = User.find(@collaboration.user_id)
      @collaboration_user = User.find(@result.user_id)
      @collaboration_comments = CollaborationComment.where(collaboration_id: @collaboration.id)
    end

    def index
      @collaborations = Collaboration.where(user_id: current_user.id)
    end

    def edit
      @collaboration = Collaboration.find(params[:id])
      @result = Result.find(@collaboration.result_id)
      @user = User.find(@collaboration.user_id)
      @collaboration_user = User.find(@result.user_id)
    end
  
    def destroy
      @collaboration = Collaboration.find(params[:id])
      @collaboration.destroy
      redirect_to user_collaborations_path(current_user)
    end
  
    def update
      @collaboration = Collaboration.find(params[:id])
      @collaboration.update(update_collaboration_params)
      redirect_to user_collaborations_path(current_user)
    end
  

    def create
      @collaboration = Collaboration.new(collaboration_params)
      @result = Result.find(@collaboration.result_id)
      @user = User.find(@result.user_id)
      @collaboration.title = "#{current_user.name}と#{@user.name}"
      @collaboration.save

      render json: { url: user_result_collaboration_path(current_user, @result, @collaboration) }

    end

    private
      def collaboration_params
        params.permit(:result_id, :user_id, :collaboration_voice)
    end

    def update_collaboration_params
      params.require(:collaboration).permit(:title, :body, :state)
    end
end
