class Result < ApplicationRecord
   mount_uploader :impersonation_voice, ImpersonationVoiceUploader
   belongs_to :target
   belongs_to :user
   has_many :comments, dependent: :destroy
   has_many :collaborations, dependent: :destroy
   after_create :analyze

   enum state: { not_published: 0, published: 1 }

   def analyze
      result = self
      target = self.target

      #APIに投げるprofile_idを5つ選ぶ。まずはtargetを除く4つのお題を抽出
      sample_profiles = Target.where.not(profile_id: target.profile_id).sample(4)
      sample_profile_ids = (0..3).map do |num|
        sample_profiles[num].profile_id
      end
      profile_ids = sample_profile_ids << target.profile_id
      profile_ids_params = profile_ids.join(',')

      result.compare(profile_ids_params, target, result)
    end

    def compare(ids, target, result)
      if Rails.env.production?
        voice = URI.open(result.impersonation_voice.url) # 本番環境のみ
      else
        voice = "/Users/beppumasaki/workspace/my_app/impersonation_practice/public" + URI.decode_www_form_component("#{result.impersonation_voice.url}") # 本番環境以外
      end 

      connection = Faraday.new(url: 'https://westus.api.cognitive.microsoft.com') do |f|
        f.request :multipart
        f.request :url_encoded
        f.response :logger
        f.adapter Faraday.default_adapter
      end
  
      #APIにprofile_ids_paramsを指定
      response = connection.post do |req|
        req.url '/speaker/identification/v2.0/text-independent/profiles/identifySingleSpeaker'
        req.headers = {
          'Ocp-Apim-Subscription-Key': Rails.application.credentials[:apiKey],
          'Content-Type': 'audio/wav',
          'Transfer-Encoding': 'chunked'
        }
        req.body = Faraday::Multipart::FilePart.new(voice, 'audio/wav')
        req.params = {
          profileIds: ids
        }
      end
      result.judge(response, target, result)
    end

    def judge(response, target, result)
      hash = JSON.parse(response.body)
      
      #profile_idのみ配列で取得
      profile_id_list = (0..4).map do |num|
        hash["profilesRanking"][num]["profileId"]
      end
      
      #targetのprofile_idと同一のものを抽出
      same_profile_id = profile_id_list.select do |x|
        x == target.profile_id
      end

      #お題のレスポンスが返ってきているprofile_idは何番目か
      same_profile_id_number = profile_id_list.index(same_profile_id*"")

      result.score = hash["profilesRanking"][same_profile_id_number]["score"]*140
      result.score = 0 if result.score < 0
      result.match_target = Target.find_by(profile_id: hash["profilesRanking"][0]["profileId"]).name
      result.save
    end
end
