class StaticPagesController < ApplicationController
  def top
    @cards = Result.where(state: "published").includes(:user, :target).order(score: :desc).limit(3)
  end
end
