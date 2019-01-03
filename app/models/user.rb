class User < ApplicationRecord
  has_many :posts
  has_many :reviews
  has_many :authorizations, dependent: :destroy
  has_many :orders, :dependent => :destroy
  has_many :bookings, :dependent => :destroy
  has_many :locations, dependent: :destroy

  attr_accessor :skip_password_validation
  attr_accessor :remember_token
  
  validates :username, presence: true, uniqueness: true

  validates :email, presence: true, uniqueness: true
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  
  validates :password, length: { minimum: 6 }, allow_nil: true, presence: true, unless: :skip_password_validation
  validates :password_confirmation, length: { minimum: 6 }, allow_nil: true, presence: true, unless: :skip_password_validation

  has_secure_password
  
 
  def has_review(restaurant_id)
    Review.find_by(user_id: self,restaurant_id: restaurant_id)
  end
  
  def has_post(restaurant_id)
    Post.find_by(user_id: self,restaurant_id: restaurant_id)
  end

  
  def self.admin?
    if User.admin==true
      return true
    else
      return false
    end
  end

  def authorize
    unless admin?
      flash[:error] = "unauthorized access"
      redirect_to home_path
      false
    end
  end
  
  def self.create_user_with_omniauth(auth)
    @user_no=User.count
    pass= SecureRandom.urlsafe_base64(n=6)
    user=User.new(id: @user_no+1, name: auth.info.name, email: auth.info.email, username: auth.info.name, oauth_token: auth.credentials.token, oauth_expires_at: Time.at(auth.credentials.expires_at),password: pass, password_confirmation: pass)
    user.save!
    user
  end
  
  def self.find_with_omniauth(auth)
    find_by(uid: auth['uid'], provider: auth['provider'])
  end

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

 
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
