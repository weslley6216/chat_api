class ChatChannel < ApplicationCable::Channel
  def subscribed
    @conversation = find_conversation
    stream_for @conversation if @conversation
  end

  def receive(data)
    user = find_user(data['user_id'])
    conversation = find_conversation(data['conversation_id'])
    message = find_message(conversation, data['message_id'])

    return unless user && conversation && message
    return unless user_in_conversation?(user, conversation)

    broadcast_to(conversation, message: MessageSerializer.new(message).as_json)
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("ChatChannel: Record not found - #{e.message}")
  rescue StandardError => e
    Rails.logger.error("ChatChannel: An error occurred - #{e.message}")
  end

  private

  def find_conversation(conversation_id = params['conversation_id'])
    Conversation.find(conversation_id)
  end

  def find_user(user_id)
    User.find(user_id)
  end

  def find_message(conversation, message_id)
    conversation&.messages&.find(message_id)
  end

  def user_in_conversation?(user, conversation)
    conversation.users.include?(user)
  end
end
