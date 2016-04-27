class RegisteredProvidersController < ApplicationController
  after_action :verify_authorized

  api :GET, '/registered_providers', 'Returns a list of registered providers'
  def index
    authorize RegisteredProvider
    respond_with registered_providers, each_serializer: RegisteredProviderSerializer
  end

  private

  def registered_providers
    @_reg_prov ||= query_with RegisteredProvider.all, :includes, :pagination
  end
end
