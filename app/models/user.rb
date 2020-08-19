class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable
  #after_create :send_confirm_mail <------------- if confirmable set
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :omniauthable, :trackable
  #page 532
  has_many :posts
  #before_destroy :destroy_pic
  mount_uploader :avatar, AvatarUploader
end
