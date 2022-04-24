class Collaboration < ApplicationRecord
  mount_uploader :collaboration_voice, CollaborationVoiceUploader
  belongs_to :user
  belongs_to :result

  enum state: { not_published: 0, published: 1 }
end
