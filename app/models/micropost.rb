class Micropost < ActiveRecord::Base
  #Micropost�͂Ƃ���User�̔z���ɓ���@���ׂ̈�('User'����\�z����)user_id�������Ă���
  belongs_to :user

  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  self.per_page = 30
end
