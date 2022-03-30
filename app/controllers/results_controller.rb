class ResultsController < ApplicationController
  def show
    @target = Target.find(1)
    @result = Result.find(params[:id])
  end

  
  def create
    @result = Result.new(result_params)
    @result.save
    @target = Target.find(@result.target_id)
    render json: { url: target_result_url(@result.target_id, @result.id) }
  end

  private

  def result_params
    params.permit(:target_id, :impersonation_voice, :score)
  end
end
