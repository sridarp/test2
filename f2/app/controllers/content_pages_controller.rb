class ContentPagesController < ApplicationController
  include SanitizeParams

  before_action :pre_hook
  after_action :verify_authorized
  after_action :post_hook

  def self.document_content_page_params
    param :body, String, desc: 'The body of the content page.'
    error code: 404, desc: MissingRecordDetection::Messages.not_found
  end

  api :GET, '/content_pages', 'Returns a collection of content pages'
  param :page, :number, required: false
  param :per_page, :number, required: false

  def index
    respond_with_params content_pages
  end

  api :GET, '/content_pages/:slug', 'Shows content page with :slug'
  param :slug, String, required: true, desc: 'The slug of this content page.'
  document_content_page_params

  def show
    respond_with_params content_page
  end

  api :POST, '/content_pages', 'Creates a content page'
  param :title, String, required: true, desc: 'The title of this content page.'
  document_content_page_params
  error code: 422, desc: ParameterValidation::Messages.missing

  def create
    authorize ContentPage
    respond_with ContentPage.create content_page_params
  end

  api :PUT, '/content_pages/:slug', 'Updates content page with :slug'
  param :slug, String, required: true, desc: 'The slug of this content page.'
  param :title, String, required: false, desc: 'The updated title of this content page.'
  document_content_page_params
  error code: 422, desc: ParameterValidation::Messages.missing

  def update
    respond_with content_page.update_attributes content_page_params
  end

  api :DELETE, '/content_pages/:slug', 'Deletes content page with :slug'
  param :slug, String, required: true, desc: 'The slug of the content page to delete.'
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def destroy
    respond_with content_page.destroy
  end

  api :PUT, '/content_pages/:slug', 'Updates content page with :slug to the version :id'
  param :slug, String, required: true, desc: 'The slug of this content page.'
  param :id, :number, required: true, desc: 'The version of the content page to be restored.'
  error code: 422, desc: ParameterValidation::Messages.missing

  def revert
    version = content_page.versions[params[:id]]
    page = version.reify
    page.save!
    respond_with page
  end

  private

  def content_page_params_with_slug
    strip_tags(params).permit(:staff_id, :slug, :title, :body)
  end

  def content_page_params
    strip_tags(params).permit(:staff_id, :title, :body)
  end

  def content_page
    @content_page = ContentPage.find(params.require(:slug)).tap { |c| authorize(c) }
  end

  def content_pages
    @content_pages ||= begin
      authorize(ContentPage)
      query_with ContentPage.all, :pagination
    end
  end

  def pre_hook
    ActiveSupport::Notifications.instrument(controller_name + '#' + action_name + '/pre_hook')
  end

  def post_hook
    ActiveSupport::Notifications.instrument(controller_name + '#' + action_name + '/post_hook')
  end
end
