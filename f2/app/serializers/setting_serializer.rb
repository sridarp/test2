# == Schema Information
#
# Table name: settings
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  type        :string           not null
#  name        :string           not null
#  description :text
#  value       :text
#  value_type  :integer          default(0)
#  default     :text
#
# Indexes
#
#  index_settings_on_type  (type)
#

class SettingSerializer < ApplicationSerializer
  attributes :id, :group, :name, :description, :value, :value_type

  def group
    object.type.split('::').last
  end

  def value
    return nil if object.password?
    object.value
  end
end
