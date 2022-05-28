class User < ApplicationRecord
  authenticates_with_sorcery!

  has_many :results, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :collaborations, dependent: :destroy
  has_many :collaboration_comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_votes, through: :likes, source: :vote

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :email, uniqueness: true
  validates :name, presence: true, length: { maximum: 10 }

  enum role: { general: 0, admin: 1 }

  def own?(object)
    id == object.user_id
  end

  def like(vote)
    like_votes << vote
  end

  def unlike(vote)
    like_votes.delete(vote)
  end

  def like?(vote)
    like_votes.include?(vote)
  end


end
