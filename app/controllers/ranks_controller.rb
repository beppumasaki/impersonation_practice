class RanksController < ApplicationController
    def index
        @ranks = Result.where(state: "published").includes(:user, :target).order(score: :desc).limit(10)
    end
end
