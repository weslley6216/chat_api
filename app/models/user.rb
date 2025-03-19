class User < ApplicationRecord
  has_secure_password

  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :conversation_users
  has_many :conversations, through: :conversation_users
  has_many :messages, foreign_key: 'sender_id'

  scope :without_conversations_with, ->(user_id) {
    existing_conversation_user_ids = Conversation.joins(:conversation_users)
                                                  .where(conversation_users: { user_id: user_id })
                                                  .joins(:users)
                                                  .pluck('users.id')
                                                  .uniq

    where.not(id: existing_conversation_user_ids).where.not(id: user_id)
  }
end
