class TargetsController < ApplicationController
  skip_before_action :require_login, only: [:show, :index]
  
  def show
    @target = Target.find(params[:id])
  end

  def index
    @targets = Target.all
  end

end
