class SessionsController < Devise::SessionsController
  respond_to :json, :html

  skip_before_action :require_no_authentication, only: :create
  skip_before_action :verify_signed_out_user, only: :destroy
  # before_action :pre_hook
  # after_action :post_hook

  api :POST, '/staff/sign_in', 'Signs user in'
  param :staff, Hash, desc: 'Staff' do
    param :email, String, required: true, desc: 'Email'
    param :password, String, required: true, desc: 'Password'
  end
  error code: 422, desc: ParameterValidation::Messages.missing

  def create
    respond_to do |format|
      format.html do
        if request.env['omniauth.auth']
          auth_hash = request.env['omniauth.auth']

          staff = Staff.find_by_auth(auth_hash)

          sign_in_and_redirect(resource_name, staff) if staff.present?
        else
          super
        end
      end
      format.json do
        self.resource = warden.authenticate(auth_options)
        if resource
          sign_in(resource_name, resource)
          api_token = ApiToken.create! staff: resource
          resource.api_token = api_token.token
          render json: resource
        else
          render json: { error: 'Invalid Login' }, status: 401
        end
      end
    end
  end

  api :DELETE, '/staff/sign_out', 'Invalidates user session'

  def destroy
    if request.headers.key?('HTTP_AUTHORIZATION') || params[:access_token]
      token = request.headers.fetch('HTTP_AUTHORIZATION', '').split(' ').last || params[:access_token]
      if warden.user == Staff.joins(:api_tokens).find_by(api_tokens: { token: token })
        ApiToken.delete_all(token: token)
      end
    end
    respond_to do |format|
      format.html do
        super
      end
      format.json do
        Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
        render json: {}, status: :ok
      end
    end
  end
end
