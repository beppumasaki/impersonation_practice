class TargetsController < ApplicationController
  
  def show
    @target = Target.find(params[:id])
  end

  def index
    @target = Target.find(1)
  end

end
