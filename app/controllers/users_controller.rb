class UsersController < ApplicationController
	def show
		#�}�C�y�[�W params[:id]������DB������擾�A��ʂ֓n��
		@user = User.find(params[:id])
	end

	def new
		#�o�^��ʂɂĎg���B�l�̓J���b�|
		@user = User.new
	end

	def create
		#�o�^��ʂœ��͂����������Ƀ��[�U�쐬���� user_params������ł�
		@user = User.new(user_params)

		if @user.save
			#���O�C������
			sign_in @user

			#���[�U�o�^�o�����惁�b�Z�[�W ���Ȃ݂� flash.now����Ȃ��̂͂��̌ナ�_�C���N�g���邩��
			flash[:success] = "Welcome to the Sample App!"

			#�}�C�y�[�W�J��
			redirect_to @user
		else
			#���[�U�쐬���s�A�o�^��ʂɖ߂�A�G���[���b�Z�[�W��\������
			render :new
		end
	end

	private

	def user_params
		#StrongParameters�Ή��Buser�K�{�A���̔z���̋����X�g�A�݂�����
		params.require(:user).permit(:name ,:email, :password, :password_confirmation)
	end
end
