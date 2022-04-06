class ResultsController < ApplicationController
  def show
    @result = Result.find(params[:id])
    @target = Target.find(@result.target_id)
  end

  
  def create
    voice = Target.find(7).target_voice.url
    response = RestClient::Request.execute(
      method: :post,
      url: 'https://westus.api.cognitive.microsoft.com/speaker/identification/v2.0/text-independent/profiles/identifySingleSpeaker',
      headers: {
        'Ocp-Apim-Subscription-Key': 'd707afb0596c47968b5e0ed7f263c9be',
        'Content-type': 'audio/wav; codecs=audio/pcm; samplerate=16000',
        params: {
          profileIds: '42408f55-0250-4679-9950-ab72672f3958,305fbca2-be86-49b9-8619-c84b8f3e4350,6253e25d-beb4-4bc9-9b42-d26f52547aeb,7df84b53-1c74-435b-a30d-3ee30f0c92b4,d7052ffb-7395-4c43-9286-719772758174,e36dbe84-f60a-45a3-b572-2120bd789a36'
        }
      },
      payload: {
        multipart: true,
        impersonation_voice: 'voice',
        'Transfer-Encoding': 'chunked'
      }
    )
   rescue RestClient::ExceptionWithResponse => e
    byebug
    @result = Result.create(result_params)
    render json: { url: target_result_url(@result.target_id, @result.id) }
  end

  private

  def result_params
    params.permit(:target_id, :impersonation_voice, :score)
  end
end
