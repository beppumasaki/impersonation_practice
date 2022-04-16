class Admin::UserSessionsController < Admin::BaseController
  skip_before_action :check_admin, only: %i[new create]
  layout 'layouts/admin_login'

  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user.role == "admin"
      redirect_to admin_root_path
      flash[:success] = "管理者ログインしました"
    else
      flash[:danger] = "管理者ログインに失敗しました"
      render :new
    end
  end

  def destroy
    logout
    redirect_to admin_login_path
    flash[:success] = "管理者ログアウトしました"
  end
end
