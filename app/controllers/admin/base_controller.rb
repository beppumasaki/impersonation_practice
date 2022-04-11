class Admin::BaseController < ApplicationController
    layout 'admin/layouts/application'
    before_action :check_admin

    private

    def not_authenticated
      redirect_to admin_login_path
    end
    # 管理者権限がないユーザーを弾く
    def check_admin
      redirect_to root_path unless current_user.admin?
    end
end
