class MotdsController < ApplicationController
  skip_before_action :require_user, only: [:show]
  after_action :verify_authorized, except: [:show]
  after_action :post_hook
  before_action :pre_hook

  def_param_group :motd_params do
    param :message, String, desc: 'Content of message of the day template', required: true
    error_codes
  end

  api :GET, '/motd', 'Returns message of the day.'
  error_codes

  def show
    respond_with_params Motd.first
  end

  api :POST, '/motd', 'Create new message of the day.'
  param_group :motd_params

  def create
    motd_create_or_update
  end

  api :PUT, '/motd', 'Updates existing message of the day.'
  param_group :motd_params

  def update
    motd_create_or_update
  end

  api :DELETE, '/motd', 'Clears the message of the day'
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def destroy
    authorize motd
    motd.destroy
    respond_with_params motd
  end

  private

  def motd_create_or_update
    authorize motd
    motd.update motd_params
    respond_with_params motd
  end

  def motd_params
    params.permit(:message).merge(staff_id: current_user.id)
  end

  def motd
    @_motd ||= Motd.first_or_initialize
  end
end
