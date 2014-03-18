module SessionsHelper
	#このヘルパはapplication_controllerでincludeされてるので全ての箇所で使える（多分
	#ならapplication_helperに書けばいんじゃねとか思うけど後で考える

	def sign_in(user)
		#ユーザ作成時、ログイン時に呼ばれる

		#毎回ログイントークン変える
		remember_token = User.new_remember_token

		#ログイントークンはクッキーで持つ。画面遷移毎にこいつを使ってユーザ確認する
		cookies.permanent[:remember_token] = remember_token

		#暗号化したログイントークンはDBに持つ
		user.update_attribute(:remember_token, User.encrypt(remember_token))

		#@current_userへユーザ格納
		self.current_user = user
	end

	def signed_in?
		#current_userが有効かどうかでログイン済かどうか判断
		!current_user.nil?
	end

	def current_user=(user)
		#アクセサ これって@current_userカプセル化出来てんの？　出来てないか
		@current_user = user
	end

	def current_user
		#2度目以降のアクセスはもちろん値を返すだけ　逆に言うと画面遷移時には最低1回はDBアクセスが発生する
		@current_user ||= User.find_by(remember_token: User.encrypt(cookies[:remember_token]))
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end
end
