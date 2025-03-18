class AuthenticationController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[login]

  def login
    user = User.where('email = ? OR username = ?', params[:email], params[:username]).first

    if user&.authenticate(params[:password])
      token = AuthenticationService.encode(user_id: user.id)
      render json: { token: token, user: UserSerializer.new(user) }, status: :ok
    else
      render json: { error: 'Invalid email, username or password' }, status: :unauthorized
    end
  end
end
