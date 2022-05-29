class TagRelationship < ApplicationRecord
  belongs_to :target
  belongs_to :tag
end
