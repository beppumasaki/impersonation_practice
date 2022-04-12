class Admin::TargetsController < Admin::BaseController

      def show
        @target = Target.find(params[:id])
      end
    
      def index
        @targets = Target.order(created_at: :desc)
      end
    
      def new
        @target = Target.new
      end
    
      def edit
        @target = Target.find(params[:id])
      end
    
      def update
        @target = Target.find(params[:id])
        if @target.update(target_params)
          redirect_to admin_target_path(@target)
        else
          render :edit
        end
      end
    
      def destroy
        @target = Target.find(params[:id])
       #apiのprofileも削除
        destroy_url = "/speaker/identification/v2.0/text-independent/profiles/#{@target.profile_id}"
    
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
    
        @target.destroy
        redirect_to admin_targets_path
      end
    
      def create
        @target = Target.new(target_params)
        #profile作成
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
        @target.profile_id = hash["profileId"]
    
        #profileの登録
        voice = "/Users/beppumasaki/workspace/my_app/impersonation_practice/public" + @target.target_voice.url
        enrollments_url = "/speaker/identification/v2.0/text-independent/profiles/#{@target.profile_id}/enrollments"
    
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
    
        if @target.save
          redirect_to admin_targets_path
        else
          render :new
        end
      end
    
      private
    
      def target_params
        params.require(:target).permit(:name, :target_voice)
      end

end
