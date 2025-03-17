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
    return [ @conversation.user_b, @conversation.user_a ] if @conversation.user_b == @current_user

    [ @conversation.user_a, @conversation.user_b ]
  end
end
