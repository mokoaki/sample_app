class Micropost < ActiveRecord::Base
  #Micropost‚Í‚Æ‚ ‚éUser‚Ì”z‰º‚É“ü‚é@‚»‚Ìˆ×‚É('User'‚©‚ç—\‘z‚µ‚½)user_id‚ðŽ‚Á‚Ä‚¢‚é
  belongs_to :user

  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  self.per_page = 30
end
