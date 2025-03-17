class ConversationsController < ApplicationController
  before_action :set_conversation, only: %i[show destroy]

  def index
    @conversations = Conversation.where(user_a: @current_user)
                                 .or(Conversation.where(user_b: @current_user))

    render json: @conversations, each_serializer: ConversationSerializer, current_user: @current_user
  end

  def show
    render json: @conversation
  end

  def create
    @conversation = Conversation.new(conversation_params)

    if @conversation.save
      render json: @conversation, status: :created
    else
      render json: @conversation.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @conversation.destroy
    head :no_content
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:id])
  end

  def conversation_params
    params.require(:conversation).permit(:user_a_id, :user_b_id)
  end
end
