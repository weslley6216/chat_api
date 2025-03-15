class ApplicationController < ActionController::API
  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    decoded = AuthenticationService.decode(token)

    if decoded && (user = User.find_by(id: decoded[:user_id]))
      @current_user = user
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  before_action :authenticate_user!
end
