class UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    return render json: @user, status: :created if @user.save

    render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit(:username, :email)
  end
end
