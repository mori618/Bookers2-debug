class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit,:update]
  
  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    @following_users =@user.user_follower
    @follower_users = @user.user_followed
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  def follows

    @user = User.find(params[:id])
    @book = Book.new
    @users = @user.user_follower
  end

  def followers
    @user = User.find(params[:id])
    @book = Book.new
    @users = @user.user_followed
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
