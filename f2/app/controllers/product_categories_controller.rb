class ProductCategoriesController < ApplicationController
  api :GET, '/product_categories', 'Returns all product categories'

  def index
    respond_with product_categories, index_respond_options
  end

  api :GET, '/product_categories/:id', 'Shows product category with :id'
  param :id, :number, required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def show
    respond_with product_category
  end

  api :POST, '/product_categories', 'Creates a product category'
  param :name, String, desc: 'Product Category Name', required: true
  param :description, String, desc: 'Product Category Description', required: true
  param :tags, Array, desc: 'Product Category Tags', required: true
  error code: 422, desc: ParameterValidation::Messages.missing

  def create
    @product_category = ProductCategory.create product_category_params
    authorize @product_category
    respond_with @product_category
  end

  api :PUT, '/product_categories', 'Creates a product category'
  param :name, String, desc: 'Product Category Name'
  param :description, String, desc: 'Product Category Description'
  param :tags, Array, desc: 'Product Category Tags', required: true
  error code: 422, desc: ParameterValidation::Messages.missing

  def update
    authorize product_category
    respond_with product_category.update! product_category_params
  end

  api :DELETE, '/groups/:id', 'Deletes product category with :id'
  param :id, :number, required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def destroy
    respond_with product_category.destroy!
  end

  private

  def index_respond_options
    { each_serializer: ProductCategorySerializer, except: [:img, :created_at, :updated_at, :deleted_at] }
  end

  def product_category_params
    params.permit(:name, :description, :img, tags: []).tap { |p| p[:tag_list] = p.delete :tags }
  end

  def product_category
    @_product_category = ProductCategory.find(params[:id]).tap { |pc| authorize pc }
  end

  def product_categories
    authorize ProductCategory
    @_product_categories = ProductCategory.all
  end
end
