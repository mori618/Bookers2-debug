class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @book = Book.new

    if @range == "User"
      @users = User.looks(params[:search], params[:word])
    else
      @books = Book.looks(params[:search], params[:word])
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end
end
