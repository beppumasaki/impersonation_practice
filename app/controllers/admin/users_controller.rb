class Admin::UsersController < Admin::BaseController
    before_action :set_user, only: %i[edit update show destroy]

  def index
    @users = User.order(created_at: :desc)
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user)
    else
      render :edit
    end
  end

  def show; end

  def destroy
    @user.destroy!
    redirect_to admin_users_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :name, :role)
  end
end
