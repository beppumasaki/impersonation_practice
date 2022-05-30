class TargetsController < ApplicationController
  skip_before_action :require_login, only: [:show, :index, :search_tag]
  
  def show
    @target = Target.find(params[:id])
  end

  def index
    @targets = Target.all
    @tag_list=Tag.all
  end

  def search_tag
    #検索結果画面でもタグ一覧表示
    @tag_list = Tag.all
    #検索されたタグを受け取る
    @tag = Tag.find(params[:tag_id])
    #検索されたタグに紐づく投稿を表示
    @targets = @tag.targets
  end

end
