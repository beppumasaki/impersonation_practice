class TagRelationship < ApplicationRecord
  belongs_to :target
  belongs_to :tag
  validates :target_id, presence: true
  validates :tag_id, presence: true
end
