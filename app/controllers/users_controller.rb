class UsersController < ApplicationController
	def show
		#マイページ params[:id]を元にDBから情報取得、画面へ渡す
		@user = User.find(params[:id])
	end

	def new
		#登録画面にて使う。値はカラッポ
		@user = User.new
	end

	def create
		#登録画面で入力した情報を元にユーザ作成する user_paramsが噛んでる
		@user = User.new(user_params)

		if @user.save
			#ログイン処理
			sign_in @user

			#ユーザ登録出来たよメッセージ ちなみに flash.nowじゃないのはこの後リダイレクトするから
			flash[:success] = "Welcome to the Sample App!"

			#マイページ遷移
			redirect_to @user
		else
			#ユーザ作成失敗、登録画面に戻り、エラーメッセージを表示する
			render :new
		end
	end

	private

	def user_params
		#StrongParameters対応。user必須、その配下の許可リスト、みたいな
		params.require(:user).permit(:name ,:email, :password, :password_confirmation)
	end
end
