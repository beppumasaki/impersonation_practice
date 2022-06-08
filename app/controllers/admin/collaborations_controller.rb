class Admin::CollaborationsController < Admin::BaseController
  def index
    @collaborations = Collaboration.order(created_at: :desc)
  end
end