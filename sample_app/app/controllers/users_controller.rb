class UsersController < ApplicationController
  # index, edit, updateアクションが実行される前、logged_in_userメソッドを実行
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'Welcome to the Sample App!'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    # update_attributesメソッドの引数はキーとバリューのハッシュとなっているため、そのままで更新をかけられる
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    # StrongParameters
    # テーブル更新時に、permitメソッドで許可したカラムしか更新できなくする
    # requireはテーブルの指定
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      # unlessは真偽値が偽の時に実行される
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # 正しいユーザーかどうか確認
    def correct_user
      # ユーザーがアクセスしようとしているURIのユーザーを取得
      @user = User.find(params[:id])
      # 上記のユーザーとセッションのユーザーを比較し、異なっていたらroot urlにリダイレクトさせる
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
