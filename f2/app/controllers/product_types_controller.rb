class ProductTypesController < ApplicationController
  after_action :verify_authorized

  api :GET, '/product_types', 'Returns a list of all product types'

  def index
    authorize ProductType
    render json: ProductType.all, each_serializer: ProductTypeSerializer
  end

  api :GET, '/product_types/:id', 'Returns information on a product type'

  def show
    render json: product_type, serializer: ProductTypeSerializer
  end

  private

  def product_type
    @_product_type ||= ProductType.find(params[:id]).tap { |pt| authorize pt }
  end
end
