class CollaborationBoardsController < ApplicationController

    def index
        @collaboration_boards = Collaboration.where(state: "published").includes(:user, :result).order(created_at: :desc)
    end
end
