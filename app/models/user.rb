class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  #フォローされるがわを取得
  has_many :relationships,class_name:"Relationship", foreign_key: "follower_id",dependent: :destroy
  #フォローしてくるがわを取得
  has_many :reverse_of_relationships,class_name:"Relationship", foreign_key: "followed_id",dependent: :destroy

  has_many :followings, through: :relationships, source: :followed #自分がフォローしている人
  has_many :followers, through: :reverse_of_relationships, source: :follower #自分をフォローしている人

  #フォローした時
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  #フォローを外すとき
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  #フォローしているか判定
  def following?(user)
    followings.include?(user)
  end


  validates :name,
    uniqueness: true,
    length: { minimum: 2, maximum: 20 }
  validates :introduction,
    length: { maximum: 50 }

  has_one_attached :profile_image
  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join("app/assets/images/no_image.jpg")
      profile_image.attach(io: File.open(file_path), filename: "default-image.jpg", content_type: "image/jpeg")
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def self.guest
    find_or_create_by!(name: "guestuser", email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end
  
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forword_match"
      @user = User.where("name LIKE?", "#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?", "%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?", "%#{word}%")
    else
      @user = User.all
    end
  end
  
end
