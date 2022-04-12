class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = login(params[:email], params[:password],params[:name])
    if @user
      redirect_back_or_to root_path, notice: 'success'
    else
      flash.now[:alert] = 'failure'
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: 'success'
  end


end
