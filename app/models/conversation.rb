class Conversation < ApplicationRecord
  has_many :conversation_users, dependent: :destroy
  has_many :users, through: :conversation_users
  has_many :messages, dependent: :destroy

  def display_name_for(user)
    other_users = users.where.not(id: user.id)
    other_users.map(&:username).join(', ').capitalize
  end

  def broadcast_message(message)
    users.each do |user|
      ChatChannel.broadcast_to self, message: MessageSerializer.new(message).as_json
    end
  end

  scope :ordered_by_last_message, ->(user_id) {
    joins(:messages)
      .joins(:conversation_users)
      .where(conversation_users: { user_id: user_id })
      .group('conversations.id')
      .order('MAX(messages.created_at) DESC')
  }
end
