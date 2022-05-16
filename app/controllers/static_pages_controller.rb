class StaticPagesController < ApplicationController
  skip_before_action :require_login, only: %i[top terms privacy info]

  def top
    @cards = Result.where(state: "published").includes(:user, :target).order(score: :desc).limit(3)
  end
end