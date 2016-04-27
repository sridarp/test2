# == Schema Information
#
# Table name: bundles
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  img         :string(255)
#  active
#  deleted
class BundlesController < ApplicationController
  def self.document_bundle_params
    param :name, String, desc: 'Bundle name'
    param :description, String, desc: 'Short description'
    param :img, String
    param :active, :bool, desc: 'Bundle is active and available in the marketplace'
    param :products, Array, desc: 'Order Items' do
      param :id, :number, required: true
    end
    error code: 422, desc: ParameterValidation::Messages.missing
  end

  api :POST, '/bundles', 'Create a bundle'
  document_bundle_params
  def create
    @_bundle = Bundle.new
    update
  end

  api :PUT, '/bundles/:id', 'Update a bundle'
  document_bundle_params
  error code: 404, desc: MissingRecordDetection::Messages.not_found
  def update
    bundle.assign_attributes(bundle_params)
    bundle.save!
    respond_with bundle
  end

  private

  def bundle
    @_bundle ||= Bundle.find(params[:id])
  end

  def bundle_params
    params.permit(:name, :description, :img, :active, :deleted)
  end
end
