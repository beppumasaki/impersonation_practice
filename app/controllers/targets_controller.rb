class TargetsController < ApplicationController
  
  def show
    @target = Target.find(params[:id])
  end

  def index
    @targets = Target.all
  end

end
