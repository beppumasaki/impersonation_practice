class TargetsController < ApplicationController
  
  def show
    @target = Target.find(params[:id])
  end

  def index
    @targets = Target.all
  end

  def new
    @target = Target.new
  end

  def edit
    @target = Target.find(params[:id])
  end

  def update
    @target = Target.find(params[:id])
    if @target.update(target_params)
      redirect_to targets_path
    else
      render :edit
    end
  end

  def create
    @target = Target.create(target_params)
    if @target.save
      redirect_to targets_path
    else
      render :new
    end
  end

  private

  def target_params
    params.require(:target).permit(:name, :target_voice)
  end

end
