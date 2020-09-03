class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable
  #after_create :send_confirm_mail <------------- if confirmable set
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :lockable, :omniauthable, :trackable
  #page 532
  has_many :posts
  has_many :user_images
  has_many :comments
  acts_as_voter
  #before_destroy :destroy_pic
  mount_uploader :avatar, AvatarUploader

  def username=(val)
    if val.nil? or val.length < 2
      raise StandardError.new("username has to be at least 2 characters long and must be set")
    end
    super(val)
    logger.info("username set is: #{val}, result #{self.username}")
  end
end
