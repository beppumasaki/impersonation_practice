class Target < ApplicationRecord
  mount_uploader :target_voice, TargetVoiceUploader
  validates :name, presence: true

  has_many :results, dependent: :destroy
  has_many :tag_relationships, dependent: :destroy
  has_many :tags, through: :tag_relationships


  def save_tag(sent_tags)
    # タグが存在していれば、タグの名前を配列として全て取得
      current_tags = self.tags.pluck(:name) unless self.tags.nil?
      # 現在取得したタグから送られてきたタグを除いてoldtagとする
      old_tags = current_tags - sent_tags
      # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
      new_tags = sent_tags - current_tags
  
      # 古いタグを消す
      old_tags.each do |old|
        self.tags.delete Tag.find_by(name: old)
      end
  
      # 新しいタグを保存
      new_tags.each do |new|
        new_tag_relationship = Tag.find_or_create_by(name: new)
        self.tags << new_tag_relationship
     end
  end


end
