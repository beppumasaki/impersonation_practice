class Result < ApplicationRecord
   mount_uploader :impersonation_voice, ImpersonationVoiceUploader
   belongs_to :target
   belongs_to :user

   enum state: { not_published: 0, published: 1 }
end
