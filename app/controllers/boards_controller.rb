class BoardsController < ApplicationController
    def index
        # @ranks = Result.where.not(user_id: 1).includes(:user, :target).order(score: :desc).limit(3).select(:score, :user_id, :target_id)
        # @ranks = Result.includes(:user, :target).order(score: :desc).limit(3).select(:score, :user_id, :target_id)
        
        @boards = Result.where(state: "published").includes(:user, :target).order(created_at: :desc)
        # @results = Result.where(state: "published").includes(:user, :target).order(created_at: :desc)
        # @collaborations = Collaboration.where(state: "published").includes(:user, :result).order(created_at: :desc)

    end
end
