# coding: utf-8
class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  respond_to :html
  authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
    render template: "errors/error_403", status: 403, layout: 'application'
  end
    
  def index
    @users = User.all
  end

  def show
    respond_with(@user)
  end

  def new
    @user = User.new
    # 初期値を代入したいならここで設定する
    # ex)
    #  @user.username = 'nanashi'
    #  @user.role_ids = [1] # :admin
    # logger.debug("!!!!!! UserController#new called")
  end
  
  def edit
  end

  def create
    # view 側が roles が :radio_buttons の場合、:role_idsは配列でないので
    # このままでは対応できない。[] を除去して、@user.role_ids = attr[:role_ids] のように
    # 自分で代入する必要がある感じ。。。わからん。。。
    # ※ 以下の update() メソッドも同じ状況である
    attr = params.require(:user).permit(:username, :email, :password, :role_ids => [])
    @user = User.create(attr)
    respond_with(@user, :location => admin_users_path)
  end
  
  def update
    attr = params.require(:user).permit(:username, :email, :password, :role_ids => [])
    # TODO: お試しnotice表示　成功したときだけ表示するようにしてある
    if @user.update(attr)
      flash[:notice] = 'User was successfully updated.'
    end
    respond_with(@user, :location => admin_users_path)
  end

  def destroy
    @user.destroy
    respond_with(@user, :location => admin_users_path)
  end
    

  private
  def set_user
    @user = User.find(params[:id])
  end

end
