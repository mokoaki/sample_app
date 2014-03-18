class SessionsController < ApplicationController
  def new
    #ここで @session を用意しなくていいのはなぜ？
    #そりゃModelが存在しないから用意できないんだろうけど
  end

  def create
    #ログイン画面から受け取ったメアドでユーザを検索
    user = User.find_by(email: params[:session][:email].downcase)

    #ユーザが存在している & パスワード認証OK？ この機能はUserモデル内のhas_secure_passwordによて実装されている
    if user && user.authenticate(params[:session][:password])
      #認証されたユーザをログインさせる
      sign_in user

      #マイページへ遷移
      redirect_to user
    else
      #ユーザ認証失敗。エラーメッセージを表示する
      flash.now[:error] = 'Invalid email/password combination'

      #ログイン画面を表示
      render 'new'
    end
  end

  def destroy
    #サインアウト処理 SessionsHelper
    sign_out

    #サイトトップへ遷移
    redirect_to root_url
  end
end
