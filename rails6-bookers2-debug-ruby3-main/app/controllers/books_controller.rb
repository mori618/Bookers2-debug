class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]
  def show
    @new_book = Book.new
    @book = Book.find(params[:id])
    @show_user = User.find(@book.user.id)
    @book_comment = BookComment.new
  end

  def index
    @book = Book.new
    if params[:lasted]
      @books = Book.lasted
    elsif params[:favo]
      @books = Book.favo
    elsif params[:favo_week]
      to = Time.current.at_end_of_day
      from = (to - 6.day).at_beginning_of_day
      @books = Book.favo_week(from, to)
    else
      @books = Book.all
    end
  end


  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title,:body)
  end
end
