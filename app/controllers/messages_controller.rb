class MessagesController < ApplicationController
  before_action :set_conversation
  before_action :set_message, only: %i[update destroy]
  before_action :authorize_conversation!

  def index
    render json: @conversation.messages
  end

  def create
    @message = @conversation.messages.new(message_params)

    return render json: @message, status: :created if @message.save

    render json: @message.errors, status: :unprocessable_entity
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
    params.require(:message).permit(:content, :sender_id, :receiver_id)
  end

  def authorize_conversation!
    if [ @conversation.user_a, @conversation.user_b ].exclude?(@current_user)
      render json: { error: 'Forbidden' }, status: :forbidden
    end
  end
end
