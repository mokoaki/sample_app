class Relationship < ActiveRecord::Base
  #RelationshipはとあるFollowerの配下に入る・・が、Followerは存在しないからな？
  #followerって名前にしてるけど、その実態はUserだから気をつけろよ？
  #外部キーは予想できるな？followerって事は自分が持ってるfollower_idを使うんだぞ？
  #それをUser.idで引けばUserが取れるだろ？それがfollowerだからな？　みたいな感じ
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  #follower_id と followed_id は絶対に必要だ、空のデータは作らせない
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
