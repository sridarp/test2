class TokenAuthenticationStrategy < Warden::Strategies::Base
  def valid?
    request.headers.key?('HTTP_AUTHORIZATION') || params[:access_token]
  end

  def authenticate!
    token = request.headers.fetch('HTTP_AUTHORIZATION', '').split(' ').last || params[:access_token]

    # Execute a single query finding the associated staff with the token
    staff = Staff.joins(:api_tokens).find_by api_tokens: { token: token }

    if staff
      staff.api_token = token
      success! staff
    else
      fail! 'Invalid or Expired Token'
    end
  end
end

Warden::Strategies.add :token_authentication, TokenAuthenticationStrategy
