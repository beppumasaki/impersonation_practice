class Result < ApplicationRecord
   mount_uploader :impersonation_voice, ImpersonationVoiceUploader
   belongs_to :target
end
