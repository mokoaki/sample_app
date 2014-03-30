class Micropost < ActiveRecord::Base
  #MicropostはとあるUserの配下に入る　その為に('User'から予想した)user_idを持っている
  belongs_to :user

  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  self.per_page = 30

  # 与えられたユーザーがフォローしているユーザー達のマイクロポストを返す。
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    self.where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)

    #こちらでも同じように動くが、followed_user_ids を発行しメモリ内に展開し、更にクエリを発行するので件数が多くなると辛くなる可能性がある
    #followed_user_ids = user.followed_user_ids
    #self.where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
  end
end
