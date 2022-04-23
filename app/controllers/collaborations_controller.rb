class CollaborationsController < ApplicationController
    
    def new
      @collaboration = Collaboration.new(collaboration_params)
      @result = Result.find(@collaboration.result_id)
    end

    private
      def collaboration_params
        params.permit(:result_id, :user_id)
    end
end
