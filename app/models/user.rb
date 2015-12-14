class User < ActiveRecord::Base

  belongs_to :game
  belongs_to :team

  mount_uploader :avatar, AvatarUploader
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable,
           :validatable, :omniauthable,
           :omniauth_providers => [:facebook, :twitter]

  validates_integrity_of  :avatar
  validates_processing_of :avatar

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      if auth.provider == "twitter"
        user.email = auth.info.nickname + "@twitter.com"
      else
        user.email = auth.info.email
      end
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
      user.remote_avatar_url = auth.info.image.gsub('http://','https://') # assuming the user model has an image
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
      if data = session["devise.twitter_data"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end
