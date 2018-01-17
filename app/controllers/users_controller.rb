class UsersController < ApplicationController
  require 'will_paginate/array'
  before_action :set_user, only: [:edit,:update,:show]
  before_action :require_same_user , only:[:edit,:update,:delete]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:sucess] = "Welcome to the alpha blog #{@user.username}"
      redirect_to root_path
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



  private
  def user_params
    params.require(:user).permit(:username,:email,:password)
  end
  def set_user
    @user = User.find(params[:id])
  end
  def require_same_user
    if logged_in? && current_user != @user
      flash[:danger] = "You can only edit your own account"
      redirect_to root_path
    end
  end
end