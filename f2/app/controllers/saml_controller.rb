class SamlController < ApplicationController
  before_action :saml_enabled?
  skip_before_action :require_user, only: :init

  def init
    respond_to do |format|
      format.html { redirect_to sso_saml_index_url }
      format.json { render json: { url: init_saml_index_url } }
    end
  end

  def sso
    settings = saml_settings
    if settings.nil?
      render action: :no_settings
      return
    end

    request = OneLogin::RubySaml::Authrequest.new
    redirect_to(request.create(settings))
  end

  def acs
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse])
    response.settings = saml_settings

    if response.is_valid?
      staff = Staff.find_by email: response.name_id

      if staff.nil?
        staff = Staff.new
        staff.email = response.name_id
        staff.password = Devise.friendly_token.first(8)
        staff.save!
      end

      sign_in_and_redirect(:staff, staff)
    else
      saml_failure
    end
  end

  # Trigger SP and IdP initiated Logout requests
  def logout
    # If we're given a logout request, handle it in the IdP logout initiated method
    if params[:SAMLRequest]
      return idp_logout_request

      # We've been given a response back from the IdP
    elsif params[:SAMLResponse]
      return process_logout_response
    elsif params[:slo]
      return sp_logout_request
    else
      reset_session
    end
  end

  # Create an SP initiated SLO
  def sp_logout_request
    # LogoutRequest accepts plain browser requests w/o paramters
    settings = saml_settings

    if settings.idp_slo_target_url.nil?
      reset_session
    else

      # Since we created a new SAML request, save the transaction_id
      # to compare it with the response we get back
      logout_request = OneLogin::RubySaml::Logoutrequest.new
      session[:transaction_id] = logout_request.uuid

      if settings.name_identifier_value.nil?
        settings.name_identifier_value = session[:user_id]
      end

      relay_state = url_for controller: 'saml', action: 'index'
      redirect_to(logout_request.create(settings, RelayState: relay_state))
    end
  end

  # After sending an SP initiated LogoutRequest to the IdP, we need to accept
  # the LogoutResponse, verify it, then actually delete our session.
  def process_logout_response
    settings = saml_settings

    logout_response = if session.key? :transation_id
                        OneLogin::RubySaml::Logoutresponse.new(params[:SAMLResponse], settings, matches_request_id: session[:transation_id])
                      else
                        OneLogin::RubySaml::Logoutresponse.new(params[:SAMLResponse], settings)
                      end

    # Validate the SAML Logout Response
    # Actually log out this session
    reset_session if logout_response.success?
  end

  # Method to handle IdP initiated logouts
  def idp_logout_request
    settings = saml_settings
    logout_request = OneLogin::RubySaml::SloLogoutrequest.new(params[:SAMLRequest])
    render inline: logger.error unless logout_request.is_valid?

    # Actually log out this session
    reset_session

    logout_response = OneLogin::RubySaml::SloLogoutresponse.new.create(settings, logout_request_id, nil, RelayState: params[:RelayState])
    redirect_to logout_response
  end

  def saml_settings
    idp_metadata_parser = OneLogin::RubySaml::IdpMetadataParser.new
    # Returns OneLogin::RubySaml::Settings prepopulated with idp metadata
    settings = idp_metadata_parser.parse_remote(ENV['SAML_REMOTE_XML_URL'])

    settings.assertion_consumer_service_url = acs_saml_index_url
    settings.assertion_consumer_logout_service_url = logout_saml_index_url
    settings.issuer = "#{metadata_saml_index_url}.xml"

    settings.name_identifier_format = ENV['SAML_IDENTIFIER']
    settings.authn_context = 'urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport'

    settings.certificate = ENV['SAML_CERTIFICATE']

    settings
  end

  def metadata
    settings = saml_settings
    meta = OneLogin::RubySaml::Metadata.new
    render xml: meta.generate(settings), content_type: 'application/samlmetadata+xml'
  end

  private

  def saml_enabled?
    return saml_failure if ENV['SAML_ENABLED'].nil?
    true
  end

  def saml_failure
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
      format.json { render json: { error: MissingRecordDetection::Messages.not_found }, status: :not_found }
    end
    false
  end
end
