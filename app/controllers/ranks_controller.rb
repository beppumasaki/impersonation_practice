class RanksController < ApplicationController
    def index
        # @ranks = Result.where.not(user_id: 1).includes(:user, :target).order(score: :desc).limit(3).select(:score, :user_id, :target_id)
        # @ranks = Result.includes(:user, :target).order(score: :desc).limit(3).select(:score, :user_id, :target_id)
        @ranks = Result.where(state: "published").includes(:user, :target).order(score: :desc)
    end
end
