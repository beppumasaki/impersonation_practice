class Target < ApplicationRecord
  mount_uploader :target_voice, TargetVoiceUploader
  validates :name, presence: true

  has_many :results, dependent: :destroy
  has_many :tag_relationships, dependent: :destroy
  has_many :tags, through: :tag_relationships
end
