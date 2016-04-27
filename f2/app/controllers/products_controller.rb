class ProductsController < ApplicationController
  PRODUCT_INCLUDES = %w(tags provider product_type answers orders).freeze

  before_action :pre_hook

  after_action :verify_authorized
  after_action :post_hook

  has_scope :active, type: :boolean

  def_param_group :product do
    param :name, String, desc: 'Product Name', action_aware: true
    param :description, String, desc: 'Short description', action_aware: true
    param :active, :bool, desc: 'Product is active and available in the marketplace', action_aware: true
    param :setup_price, :decimal, precision: 10, scale: 4, desc: 'Initial Setup Fee', action_aware: true
    param :monthly_price, :decimal, precision: 10, scale: 4, desc: 'Cost per Month', action_aware: true
    param :hourly_price, :decimal, precision: 10, scale: 4, desc: 'Cost per Hour', action_aware: true
    param :product_type_id, :number, desc: 'Product Type', action_aware: true
    param :tags, Array, desc: 'List of tags', action_aware: true
    param_group :answers, ApplicationController
    error code: 422, desc: ParameterValidation::Messages.missing
  end

  api :GET, '/products', 'Returns a collection of products'
  param :page, :number
  param :per_page, :number
  param :active, :bool
  param :includes, Array, in: PRODUCT_INCLUDES

  def index
    authorize Product
    respond_with_params products, index_respond_options
  end

  api :GET, '/products/:id', 'Shows product with :id'
  param :id, :number, required: true
  param :includes, Array, in: PRODUCT_INCLUDES
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def show
    authorize product
    respond_with_params product, serializer: ProductSerializer
  end

  api :POST, '/products', 'Creates product'
  param_group :product

  def create
    product = product_class.new product_params
    authorize product
    product.save!
    respond_with product, serializer: ProductSerializer, location: product_url(product)
  end

  api :PUT, '/products/:id', 'Updates product with :id'
  param_group :product
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def update
    product.update_attributes product_params
    respond_with product, serializer: ProductSerializer
  end

  api :DELETE, '/products/:id', 'Deletes product with :id'
  param :id, :number, required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def destroy
    authorize product
    product.destroy
    respond_with product, serializer: ProductSerializer
  end

  private

  def index_respond_options
    { each_serializer: ProductSerializer, except: [:order_questions, :active, :deleted_at] }
  end

  def product_params
    params.permit(:name, :description, :img, :active, :hourly_price, :monthly_price, :setup_price,
      :provider_id, :product_type_id, tags: [], answers: [:id, :name, :value, :value_type]).tap do |par|
      par[:tag_list] = par.delete :tags
      par[:answers_attributes] = par.delete(:answers) || []
    end
  end

  def products
    @_products ||= query_with apply_scopes(Product.all), :includes, :pagination, :tags_list
  end

  def product
    @_product ||= Product.find(params[:id]).tap { |pr| authorize pr }
  end

  def product_class
    @_product_class ||= ProductType.find(params[:product_type_id]).product_class
  end
end
