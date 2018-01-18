class UsersController < ApplicationController
  require 'will_paginate/array'
  before_action :set_user, only: [:edit,:update,:show]
  before_action :require_same_user , only:[:edit,:updated, :destroy]
  before_action :require_admin, only: [:destroy]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:sucess] = "Welcome to the alpha blog #{@user.username}"
      session[:user_id] = @user.id
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end


  def edit
  end

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:sucess] = "#{@user.username} your account has been updated"
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:sucess] = "User was destroyed"
    redirect_to users_path
  end



  private
  def user_params
    params.require(:user).permit(:username,:email,:password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if !current_user != @user and !current_user.admin?
      flash[:danger] = "You can only edit your own account"
      redirect_to root_path
    end
  end

  def require_admin
    if logged_in? && !current_user.admin?
      flash[:danger] = "Only admins can perfrom that actions"
      redirect_to root_path
    end
  end

end