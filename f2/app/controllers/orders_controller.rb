class OrdersController < ApplicationController
  include Wisper::Publisher

  ORDER_INCLUDES = %w(staff products project services answers).freeze

  after_action :verify_authorized, except: [:create]

  api :GET, '/orders', 'Returns all orders'
  param :page, :number, required: false
  param :per_page, :number, required: false
  param :includes, Array, in: ORDER_INCLUDES
  error code: 422, desc: ParameterValidation::Messages.missing

  def index
    authorize Order
    respond_with_params orders, index_respond_options
  end

  api :GET, '/orders/:id', 'Returns an order by :id'
  param :id, :number
  param :includes, Array, in: ORDER_INCLUDES
  error code: 404, desc: MissingRecordDetection::Messages.not_found
  error code: 422, desc: ParameterValidation::Messages.missing

  def show
    authorize order
    respond_with_params order
  end

  api :POST, '/orders', 'Make a new service order'
  param :project_id, :number, desc: 'Related project id', required: true
  param :products, Array do
    param :product_id, :number, desc: 'Related product id', required: true
    param :service, Hash, required: true do
      param :name, String, desc: 'Name of the new service', required: true
    end
  end

  param_group :answers, ApplicationController
  error code: 422, desc: ParameterValidation::Messages.missing

  def create
    use_case = CreateServiceOrder.perform(current_user, order_params)
    respond_with use_case.order, location: orders_url
  rescue UseCase::Error => e
    fail_with error: e.message, type: e.class.to_s.split('::').last
  end

  private

  def index_respond_options
    { each_serializer: OrderSerializer, except: [:staff_id, :setup_price, :status_msg, :updated_at, :deleted_at] }
  end

  def order_params
    params.permit(:project_id, products: [:product_id, service: [:name], answers: [:value, :value_type, :name]]).tap do |o|
      o[:products].each do |product|
        product[:service]['answers_attributes'] = product.delete(:answers) || []
      end
    end
  end

  def orders
    @_orders ||= query_with Order.all, :includes, :pagination
  end

  def order
    @_order ||= query_with Order.find(params[:id])
  end
end
