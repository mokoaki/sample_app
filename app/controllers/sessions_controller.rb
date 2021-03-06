class SessionsController < ApplicationController
  def new
    #ここで @session を用意しなくていいのはなぜ？
    #そりゃModelが存在しないから用意できないんだろうけど
    #あとでその理由が明かされる？のか？
  end

  def create
    #ログイン画面から受け取ったメアドでユーザを検索
    user = User.find_by(email: params[:email].downcase)

    #ユーザが存在している & パスワード認証OK？ この機能はUserモデル内のhas_secure_passwordによて実装されている
    if user && user.authenticate(params[:password])
      #認証されたユーザをログインさせる
      sign_in user

      #フレンドリーフォワーディング、もしくはマイページへ遷移
      redirect_back_or user
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
