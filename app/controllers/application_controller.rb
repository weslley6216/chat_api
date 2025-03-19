class ApplicationController < ActionController::API
  before_action :authenticate_user!

  private

  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    return unauthorized_response unless token

    decoded = AuthenticationService.decode(token)
    return unauthorized_response unless decoded

    user = User.find_by(id: decoded[:user_id])
    return user_not_found_response(decoded[:user_id]) unless user

    @current_user = user
  end

  def unauthorized_response
    Rails.logger.error('Token Decode Failed')
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def user_not_found_response(user_id)
    Rails.logger.error("User Not Found: #{user_id}")
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
