class Like < ApplicationRecord
  belongs_to :user
  belongs_to :vote

  validates :user_id, uniqueness: { scope: :vote_id }
end
