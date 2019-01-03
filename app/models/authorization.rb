class Authorization < ApplicationRecord
  belongs_to :user
  
  def self.find_with_omniauth(auth)
    find_by(uid: auth['uid'], provider: auth['provider'])
  end

  def self.create_with_omniauth(auth,user)
    authorize=Authorization.new(uid: auth['uid'], provider: auth['provider'],user_id: user)
    authorize.save!
    authorize
  end

end
