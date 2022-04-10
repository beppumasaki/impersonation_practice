class ResultsController < ApplicationController

  def show
    @result = Result.find(params[:id])
    @target = Target.find(@result.target_id)
  end

  
  def create
    @result = Result.new(result_params)
    @target = Target.find(@result.target_id)
    voice = "/Users/beppumasaki/workspace/my_app/impersonation_practice/public" + @result.impersonation_voice.url
    connection = Faraday.new(url: 'https://westus.api.cognitive.microsoft.com') do |f|
      f.request :multipart
      f.request :url_encoded
      f.response :logger
      f.adapter Faraday.default_adapter
    end

    #profile_idを5個から選ぶ
      sample_profiles = Target.where.not(profile_id: @target.profile_id).sample(4)
  
      sample_profile_ids = (0..3).map do |num|
        sample_profiles[num].profile_id
      end
      profile_ids = sample_profile_ids << @target.profile_id
      profile_ids_params = profile_ids.join(',')



    response = connection.post do |req|
      req.url '/speaker/identification/v2.0/text-independent/profiles/identifySingleSpeaker'
      req.headers = {
        'Ocp-Apim-Subscription-Key': 'd707afb0596c47968b5e0ed7f263c9be',
        'Content-Type': 'audio/wav',
        'Transfer-Encoding': 'chunked'
      }
      req.body = Faraday::Multipart::FilePart.new(voice, 'audio/wav')
      req.params = {
        profileIds: profile_ids_params
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
