class ResultsController < ApplicationController
  skip_before_action :require_login, only: %i[show create]
  before_action :set_result, only: %i[show edit update destroy]
  before_action :user_check, only: %i[edit update destroy]
  before_action :set_target, only: %i[show edit]

  def show
    @user = @result.user
    @comments = @result.comments
    @comment = Comment.new
  end

  def index
    @results = current_user.results
  end

  def edit; end

  def destroy
    @result.destroy
    redirect_to results_path
  end

  def update
    @result.update(update_result_params)
    redirect_to results_path
  end
  
  def create
    @result = Result.new(result_params)
    @result.user_id = current_user.id if current_user
    @result.save

    render json: { url: result_url(@result) }
  end

  private

  def set_result
    @result = Result.find(params[:id])
  end

  def set_target
    @target = Target.find(@result.target_id)
  end

  def result_params
    params.permit(:target_id, :impersonation_voice, :score, :user_id)
  end

  def update_result_params
    params.require(:result).permit(:body, :state)
  end

  def user_check
    @user = @result.user
    redirect_to root_path if current_user != @user
  end

end
