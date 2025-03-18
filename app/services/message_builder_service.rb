class MessageBuilderService
  def initialize(conversation, current_user, params)
    @conversation = conversation
    @current_user = current_user
    @params = params
  end

  def build_message
    sender, receiver = determine_sender_and_receiver
    return unless sender

    @conversation.messages.build(@params.merge(sender: sender, receiver: receiver))
  end

  private

  def determine_sender_and_receiver
    sender = @current_user
    receiver = @conversation.users.find { |user| user != sender }

    return [ sender, receiver ] if receiver

    [ nil, nil ]
  end
end
