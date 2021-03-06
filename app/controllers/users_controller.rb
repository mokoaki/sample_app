class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]
  before_action :login_user_goto_root, only: [:new, :create]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    #マイページ params[:id]を元にDBから情報取得、画面へ渡す
    #このページは認証してないユーザにも見える。だからGETでID指定出来る。
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    #登録画面にて使う。値はカラッポ
    @user = User.new
  end

  def create
    #登録画面で入力した情報を元にユーザ作成する user_paramsが一枚噛んでる
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

  def edit
    #correct_userが動いてるからこの行はもうイラン
    #@user = User.find(params[:id])
  end

  def update
    #correct_userが動いてるからこの行はもうイラン
    #@user = User.find(params[:id])

    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])

    if current_user?(user)
      redirect_to(root_path)
    else
      user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    #StrongParameters対応。user必須でその配下の許可リスト、みたいな
    params.require(:user).permit(:name ,:email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def login_user_goto_root
    redirect_to(root_path) if signed_in?
  end
end
