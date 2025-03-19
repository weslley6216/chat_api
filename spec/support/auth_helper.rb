module AuthHelper
  def auth_token_header(user)
    token = AuthenticationService.encode({ user_id: user.id })
    { 'Authorization': "Bearer #{token}" }
  end
end
