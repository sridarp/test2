class SettingsController < ApplicationController
  after_action :verify_authorized

  api :GET, '/settings', 'Get all settings in the system'
  def index
    authorize Setting
    respond_with settings, each_serializer: SettingSerializer
  end

  api :PUT, '/settings/:name', 'Update a setting value'
  param :name, String, desc: 'Setting name', required: true
  param :value, String, desc: 'Setting value replacement', required: true
  def update
    setting.update value: params[:value]
    respond_with setting, serializer: SettingSerializer
  end

  private

  def settings
    @_settings ||= Setting.all
  end

  def setting
    @_setting ||= Setting.find_by(name: params[:name]).tap { |s| authorize s }
  end
end
