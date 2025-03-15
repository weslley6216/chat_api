class ApplicationController < ActionController::API
  before_action :authenticate_user!

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    decoded = AuthenticationService.decode(token)

    if decoded && (user = User.find_by(id: decoded[:user_id]))
      @current_user = user
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
