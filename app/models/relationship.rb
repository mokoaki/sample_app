class Relationship < ActiveRecord::Base
  #Relationship�͂Ƃ���Follower�̔z���ɓ���E�E���AFollower�͑��݂��Ȃ�����ȁH
  #follower���Ė��O�ɂ��Ă邯�ǁA���̎��Ԃ�User������C�������H
  #�O���L�[�͗\�z�ł���ȁHfollower���Ď��͎����������Ă�follower_id���g���񂾂��H
  #�����User.id�ň�����User�����邾��H���ꂪfollower������ȁH�@�݂����Ȋ���
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  #follower_id �� followed_id �͐�΂ɕK�v���A��̃f�[�^�͍�点�Ȃ�
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
