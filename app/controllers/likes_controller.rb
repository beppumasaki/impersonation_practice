class LikesController < ApplicationController

    def create
        @vote = Vote.find(params[:vote_id])
        current_user.like(@vote)
        redirect_back fallback_location: votes_path
    end
    
    def destroy
        @vote = current_user.likes.find(params[:id]).vote
        current_user.unlike(@vote)
        redirect_back fallback_location: votes_path
    end

end
