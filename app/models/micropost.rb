class Micropost < ActiveRecord::Base
  #MicropostはとあるUserの配下に入る　その為に('User'から予想した)user_idを持っている
  belongs_to :user

  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  self.per_page = 30
end
