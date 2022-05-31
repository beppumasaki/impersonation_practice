class Target < ApplicationRecord
  mount_uploader :target_voice, TargetVoiceUploader
  validates :name, presence: true

  has_many :results, dependent: :destroy
  has_many :tag_relationships, dependent: :destroy
  has_many :tags, through: :tag_relationships

  def api_destroy(target)
    destroy_url = "/speaker/identification/v2.0/text-independent/profiles/#{target.profile_id}"
    destroy_connection = Faraday.new(url: 'https://westus.api.cognitive.microsoft.com') do |f|
      f.request :multipart
      f.request :json
      f.response :logger
      f.adapter Faraday.default_adapter
    end

    destroy_response = destroy_connection.delete do |destroy_req|
      destroy_req.url destroy_url
      destroy_req.headers = {
        'Ocp-Apim-Subscription-Key': Rails.application.credentials[:apiKey]
      }
    end
  end


  def get_profile(target)
    create_connection = Faraday.new(url: 'https://westus.api.cognitive.microsoft.com') do |f|
      f.request :multipart
      f.request :json
      f.response :logger
      f.adapter Faraday.default_adapter
    end

    create_response = create_connection.post do |create_req|
      create_req.url '/speaker/identification/v2.0/text-independent/profiles'
      create_req.headers = {
        'Ocp-Apim-Subscription-Key': Rails.application.credentials[:apiKey],
        'Content-Type': 'application/json'
      }
      create_req.body = {
        locale: "en-us"
      }
    end
    hash = JSON.parse(create_response.body)
    target.profile_id = hash["profileId"]
  end


  def enrollment_voice(target)
    if Rails.env.production?
      voice = URI.open(target.target_voice.url) # 本番環境のみ
    else
      voice = "/Users/beppumasaki/workspace/my_app/impersonation_practice/public" + URI.decode_www_form_component("#{target.target_voice.url}") # 本番環境以外
    end

    enrollments_url = "/speaker/identification/v2.0/text-independent/profiles/#{target.profile_id}/enrollments"
    
    enrollments_connection = Faraday.new(url: 'https://westus.api.cognitive.microsoft.com') do |f|
      f.request :multipart
      f.request :url_encoded
      f.response :logger
      f.adapter Faraday.default_adapter
    end

    enrollments_response = enrollments_connection.post do |enrollments_req|
      enrollments_req.url enrollments_url 
      enrollments_req.headers = {
      'Ocp-Apim-Subscription-Key': Rails.application.credentials[:apiKey],
      'Content-Type': 'audio/wav',
      'Transfer-Encoding': 'chunked'
      }
      enrollments_req.body = Faraday::Multipart::FilePart.new(voice, 'audio/wav')
    end
  end

end
