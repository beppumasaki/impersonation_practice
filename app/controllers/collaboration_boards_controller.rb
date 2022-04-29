class CollaborationBoardsController < ApplicationController

    def index
        
        # @boards = Result.where(state: "published").includes(:user, :target).order(created_at: :desc)
       
        @collaboration_boards = Collaboration.where(state: "published").includes(:user, :result).order(created_at: :desc)

    end
end
