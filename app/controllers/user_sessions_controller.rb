class UserSessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to root_path, flash: {success: "ログインしました"}
    else
      flash.now[:alert] = 'ログアウトしました'
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: 'success'
  end
end
