class Collaboration < ApplicationRecord
  mount_uploader :collaboration_voice, CollaborationVoiceUploader
  belongs_to :user
  belongs_to :result
end
