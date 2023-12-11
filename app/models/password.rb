class Password < ApplicationRecord
  has_many :user_passwords, dependent: :destroy
  has_many :users, through: :user_passwords

  encrypts :username, deterministic: true
  encrypts :password

  validates :username, presence: true
  validates :password, presence: true
  validates :url, presence: true

  def shareable_users
    User.excluding(users)
  end

  def can_edit?(user)
    user_passwords.find_by(user: user).editable?
  end

  def can_share?(user)
    user_passwords.find_by(user: user).shareable?
  end

  def can_delete?(current_user)
    user_passwords.find_by(user: current_user).deletable?
  end
end
