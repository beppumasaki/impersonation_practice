class ResultsController < ApplicationController
  skip_before_action :require_login, only: %i[show create]
  before_action :set_result, only: %i[show edit update destroy]
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
    @result = Result.create(result_params)
    @result.user_id = current_user.id if current_user
    @target = Target.find(@result.target_id)
    
    response = @result.analyse(@target, @result)
    @result.judge(response, @target, @result)
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

  #voiceに定義したURlがエンコード文字列では認識されないため、newではなくcreate。not null制約つけているので一時的にscoreに値を追加。
  def result_params
    params.permit(:target_id, :impersonation_voice, :score, :user_id)
  end

  def update_result_params
    params.require(:result).permit(:body, :state)
  end

end
