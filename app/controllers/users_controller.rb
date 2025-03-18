class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[create]

  def index
    users = User.where.not(id: @current_user.id)
    render json: users, each_serializer: UserSerializer
  end

  def create
    @user = User.new(user_params)

    return render json: @user, serializer: UserSerializer, status: :created if @user.save

    render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
