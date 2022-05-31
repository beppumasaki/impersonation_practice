class RanksController < ApplicationController
    def index
        @ranks = Result.where(state: "published").includes(:user, :target).order(score: :desc)
    end
end
