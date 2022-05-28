class Collaboration < ApplicationRecord
  mount_uploader :collaboration_voice, CollaborationVoiceUploader
  belongs_to :user
  belongs_to :result
  has_many :collaboration_comments, dependent: :destroy

  enum state: { not_published: 0, published: 1 }
end
