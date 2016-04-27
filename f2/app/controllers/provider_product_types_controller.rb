class ProviderProductTypesController < ApplicationController
  after_action :verify_authorized

  api :GET, '/provider/:provider_id/product_types', 'Returns a collection of product types related to a provider'
  param :page, :number
  param :per_page, :number

  def index
    respond_with_params product_types, each_serializer: ProductTypeSerializer
  end

  private

  def provider
    @_provider ||= Provider.find(params[:provider_id]).tap { |p| authorize p }
  end

  def product_types
    @_product_types ||= query_with ProductType.where(provider_type: provider.type), :includes, :pagination
  end
end
