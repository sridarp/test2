class ExtensionsController < ApplicationController
  skip_before_action :require_user

  api :GET, '/api/v1/extensions', 'Returns a list of all extensions installed into Jellyfish'
  def index
    respond_with Jellyfish::Extension.all, each_serializer: ExtensionSerializer
  end
end
