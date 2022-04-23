class CollaborationsController < ApplicationController
    
    def new
      @collaboration = Collaboration.new(collaboration_params)
      @result = Result.find(@collaboration.result_id)
    end

    def show
      if params[:id] == "undefined"
        @result = Result.find(params[:result_id])
        redirect_to user_result_collaborations_path(current_user, @result)
      else
        #ここから処理記載
       redirect_to root_path
      end
    end

    def index
      # redirect_to root_path
    end

    def create
      @collaboration = Collaboration.create(collaboration_params)
      @result = Result.find(@collaboration.result_id)

      # 自動でcreate後にshowアクションが呼び出されてしまう不具合によりコメントアウト
      # if @collaboration
      #   redirect_to user_result_collaborations_path(current_user, @result)
      # else
      #   redirect_to new_user_result_collaboration_path(current_user, @result, @collaboration)
      # end

    end
  

    private
      def collaboration_params
        params.permit(:result_id, :user_id, :collaboration_voice)
    end
end
