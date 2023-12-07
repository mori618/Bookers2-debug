class Book < ApplicationRecord
  belongs_to :user
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :book_comments, dependent: :destroy
  scope :lasted, -> {order(created_at: :desc) }
  scope :favo, -> { includes(:favorited_users)
    .sort_by { |x| x.favorited_users.includes(:favorites).size }.reverse }
  scope :favo_week, -> (from, to) { includes(:favorited_users)
    .sort_by { |x| x.favorited_users.includes(:favorites).where(created_at: from...to).size }.reverse }

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end
end
