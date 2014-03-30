class User < ActiveRecord::Base
  #User.save前にメアドを小文字化
  before_save { self.email.downcase! }

  #User.create前にリメンバートークン初期値を保存する用意
  before_create :create_remember_token

  #BCrypt関係、メアド暗号化、その認証のあたりを勝手に実装してくれるありがたい奴
  has_secure_password

  #User は複数の Micropost を持つ。各 Micropost は自分が配下になっている user_id を持っている
  #User が削除される時、その配下の Micropost も一緒に削除される。それってdestroyの時だけ？deleteの時はどうなの？コールバック的に？
  has_many :microposts, dependent: :destroy

  #User は複数の relationship を持つ。その時のModel名は・・もちろん予想出来るな？ Relationship だ
  #その時のキーは user_id ではなく follower_id を使う事にする
  #User が削除される時、その配下の Relationship も一緒に削除される（follower_idにUser.idを持つレコードも消える）
  has_many :relationships, foreign_key: 'follower_id', dependent: :destroy

  #User は複数の followed_users を持つ・・が、FollowedUser は存在しないからな？
  #followed_users って名前にしてるけど、その実態は 上で定義してる relationships だから気をつけろよ？
  #followed_users から followed_user_id を推測したか？、残念、それは無いんだ。 followed_id を使うんだ
  has_many :followed_users, through: :relationships, source: :followed

  #User は複数の reverse_relationships を持つ・・が、ReverseRelationship は存在しないからな？
  #reverse_relationships って名前にしてるけど、その実態は Relationship だから気をつけろよ？
  #その時のキーは user_id ではなく followed_id を使う事にする
  #User が削除される時、その配下の Relationship も一緒に削除される（followed_idにUser.idを持つレコードも消える）
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy

  #User は複数の followers を持つ・・が、Follower は存在しないからな？
  #followers って名前にしてるけど、その実態は 上で定義してる reverse_relationships だから気をつけろよ？
  #source: :follower は省略した。followers から follower_id を使うって推測できるだろ？
  has_many :followers, through: :reverse_relationships

  #バリデートチェックもしてくれるし、エラーメッセージも作ってくれる
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence:   true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  #Userで始まっているのはクラスメソッド。インスタンスメソッドではない
  def User.new_remember_token
    #ランダム文字列
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    #暗号化
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Micropost.where("user_id = ?", id)
  end

  def following?(other_user)
    #find_byを使うという事は、見つからない場合はnilを返すと言う事
    # User or nil => true or false みたいに判断できるって事
    self.relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    self.relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    #selectしてから削除してて気持ち悪くね？
    #昔はdestroy(id)とかやってなかったっけ？後で確認する
    relationships.find_by(followed_id: other_user.id).destroy
  end

  private

  def create_remember_token
    #リメンバートークン初期値　この値はログインするたびに変わる
    self.remember_token = User.encrypt(User.new_remember_token)
  end
end
