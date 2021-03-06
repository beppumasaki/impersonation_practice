class VotesController < ApplicationController

    def new
      @vote = Vote.new
    end

    def index
      @votes = Vote.all
    end

    def create
      @vote = Vote.new(vote_params)
      @vote.user_id = current_user.id
      if @vote.save
        redirect_to votes_path
      else
        render :new
      end
    end

    def destroy
        @vote = Vote.find(params[:id])
        @vote.destroy
        redirect_to votes_path
    end

    def likes
      @votes = current_user.like_votes
    end

    private

    def vote_params
      params.require(:vote).permit(:name)
    end

end
