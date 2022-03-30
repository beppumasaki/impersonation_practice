class ResultsController < ApplicationController
  def show
    @target = Target.find(params[:id])
  end

  
  def create
    @target = Target.find(params[:id])
    @result = Result.new(result_params)
    @result.score = 100
    @result.save
    render action: :show
  end

  private

  def result_params
    params.permit(:target_id, :impersonation_voice)
  end
end
