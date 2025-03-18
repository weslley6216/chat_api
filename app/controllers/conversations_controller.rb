class ConversationsController < ApplicationController
  before_action :set_conversation, only: %i[show destroy]

  def index
    @conversations = Conversation.ordered_by_last_message(@current_user.id)

    render json: @conversations, each_serializer: ConversationSerializer, current_user: @current_user
  end

  def show
    if @conversation.users.include?(@current_user)
      render json: @conversation, serializer: ConversationSerializer, current_user: @current_user
    else
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end

  def create
    @conversation = Conversation.new
    @conversation.conversation_users.build(user: @current_user)
    @conversation.conversation_users.build(user: User.find_by(id: conversation_params[:user_id]))

    if @conversation.save
      render json: @conversation, serializer: ConversationSerializer, current_user: @current_user, status: :created
    else
      render json: @conversation.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @conversation.users.include?(@current_user)
      @conversation.destroy
      head :no_content
    else
      render json: { error: 'Unauthorized' }, status: :forbidden
    end
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def conversation_params
    params.require(:conversation).permit(:user_id)
  end
end
