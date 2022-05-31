class BoardsController < ApplicationController
    skip_before_action :require_login, only: %i[index]

    def index
        @boards = Result.where(state: "published").includes(:user, :target).order(created_at: :desc)
    end
end
