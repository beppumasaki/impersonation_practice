class Target < ApplicationRecord
  mount_uploader :target_voice, TargetVoiceUploader
  validates :name, presence: true

  has_many :results, dependent: :delete_all
end
