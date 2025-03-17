class MessagesController < ApplicationController
  before_action :set_conversation
  before_action :set_message, only: %i[update destroy]
  before_action :authorize_conversation!

  def index
    render json: @conversation.messages, each_serializer: MessageSerializer
  end

  def create
    message = MessageBuilderService.new(@conversation, @current_user, message_params).build_message

    return render json: message, status: :created if message.save

    render json: message.errors, status: :unprocessable_entity
  end

  def update
    return render json: @message if @message.update(message_params)

    render json: @message.errors, status: :unprocessable_entity
  end

  def destroy
    @message.destroy
    head :no_content
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def set_message
    @message = @conversation.messages.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def authorize_conversation!
    return if [ @conversation.user_a, @conversation.user_b ].include?(@current_user)

    render json: { error: 'Forbidden' }, status: :forbidden
  end
end
