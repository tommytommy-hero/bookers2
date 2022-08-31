class RelationshipsController < ApplicationController

  #フォローする
  #follow内でフォロー（作成）は定義済み
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end
  #フォローを外す
  #unfollowで外す（削除）は定義済み
  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  #フォロー一覧
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
end
