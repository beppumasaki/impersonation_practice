class ResultsController < ApplicationController
  def show
    @result = Result.find(params[:id])
    @target = Target.find(@result.target_id)
  end

  
  def create
#Faradayで検証 
    @result = Result.create(result_params)
    voice = "/Users/beppumasaki/workspace/my_app/impersonation_practice/public" + @result.impersonation_voice.url
    connection = Faraday.new(url: 'https://westus.api.cognitive.microsoft.com') do |f|
      f.request :multipart
      f.request :url_encoded
      f.response :logger
      f.adapter Faraday.default_adapter
    end

    response = connection.post do |req|
      req.url '/speaker/identification/v2.0/text-independent/profiles/identifySingleSpeaker'
      req.headers = {
        'Ocp-Apim-Subscription-Key': 'd707afb0596c47968b5e0ed7f263c9be',
        'Content-Type': 'audio/wav',
        'Transfer-Encoding': 'chunked'
      }
      req.body = Faraday::Multipart::FilePart.new(voice, 'audio/wav')

      req.params = {
        profileIds: '42408f55-0250-4679-9950-ab72672f3958,305fbca2-be86-49b9-8619-c84b8f3e4350,6253e25d-beb4-4bc9-9b42-d26f52547aeb,7df84b53-1c74-435b-a30d-3ee30f0c92b4,d7052ffb-7395-4c43-9286-719772758174,e36dbe84-f60a-45a3-b572-2120bd789a36'
      }
    end
    byebug

#RestClient::Requestで検証
    # request = RestClient::Request.new(
    #   method: :post,
    #   url: 'https://westus.api.cognitive.microsoft.com/speaker/identification/v2.0/text-independent/profiles/identifySingleSpeaker',
    #   headers: {
    #     'Ocp-Apim-Subscription-Key': 'd707afb0596c47968b5e0ed7f263c9be',
    #     'Content-type': 'audio/wav; codecs=audio/pcm; samplerate=16000',
    #     'Transfer-Encoding': 'chunked',
    #     params: {
    #       profileIds: '42408f55-0250-4679-9950-ab72672f3958,305fbca2-be86-49b9-8619-c84b8f3e4350,6253e25d-beb4-4bc9-9b42-d26f52547aeb,7df84b53-1c74-435b-a30d-3ee30f0c92b4,d7052ffb-7395-4c43-9286-719772758174,e36dbe84-f60a-45a3-b572-2120bd789a36'
    #     }
    #   },
    #   payload: File.new("/Users/beppumasaki/workspace/my_app/impersonation_practice/public/uploads/result/impersonation_voice/19/voice.wav",'rb')
    # )
    render json: { url: target_result_url(@result.target_id, @result.id) }
  end

  private

  def result_params
    params.permit(:target_id, :impersonation_voice, :score)
  end
end
