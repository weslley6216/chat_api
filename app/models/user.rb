class User < ApplicationRecord
  has_secure_password

  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :conversations_as_user_a, class_name: 'Conversation', foreign_key: 'user_a_id'
  has_many :conversations_as_user_b, class_name: 'Conversation', foreign_key: 'user_b_id'
end
