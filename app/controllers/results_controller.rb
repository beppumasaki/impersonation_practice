class ResultsController < ApplicationController
  def show
    @result = Result.find(params[:id])
    @target = Target.find(@result.target_id)
  end

  
  def create
    @result = Result.new(result_params)
    voice = "/Users/beppumasaki/workspace/my_app/impersonation_practice/public" + @result.impersonation_voice.url
    connection = Faraday.new(url: 'https://westus.api.cognitive.microsoft.com') do |f|
      f.request :multipart
      f.request :url_encoded
      f.response :logger
      f.adapter Faraday.default_adapter
    end

    #profile_idを5個から選ぶ

    response = connection.post do |req|
      req.url '/speaker/identification/v2.0/text-independent/profiles/identifySingleSpeaker'
      req.headers = {
        'Ocp-Apim-Subscription-Key': 'd707afb0596c47968b5e0ed7f263c9be',
        'Content-Type': 'audio/wav',
        'Transfer-Encoding': 'chunked'
      }
      req.body = Faraday::Multipart::FilePart.new(voice, 'audio/wav')
      req.params = {
        profileIds: '42408f55-0250-4679-9950-ab72672f3958,6253e25d-beb4-4bc9-9b42-d26f52547aeb,7df84b53-1c74-435b-a30d-3ee30f0c92b4,d7052ffb-7395-4c43-9286-719772758174,e36dbe84-f60a-45a3-b572-2120bd789a36'
      }
    end

    def judge(response)
      @target = Target.find(@result.target_id)
      hash = JSON.parse(response.body)
      
      #profile_idのみ配列で取得
      profile_id_list = (0..4).map do |num|
        hash["profilesRanking"][num]["profileId"]
      end
      
      #targetのprofile_idと同一のものを抽出
      same_profile_id = profile_id_list.select do |x|
        x == @target.profile_id
      end
      
        # #文字列に変換
        # same_profile_id_s = same_profile_id*""

        #お題のレスポンスが返ってきているprofile_idは何番目か
        same_profile_id_number = profile_id_list.index(same_profile_id*"")
      
        @result.score = hash["profilesRanking"][same_profile_id_number]["score"]*100

        @result.match_target = Target.find_by(profile_id: hash["profilesRanking"][0]["profileId"]).name
    end
    judge(response)
    @result.save
    render json: { url: target_result_url(@result.target_id, @result.id) }
  end

  private

  def result_params
    params.permit(:target_id, :impersonation_voice)
  end
end
