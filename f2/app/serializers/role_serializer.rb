# == Schema Information
#
# Table name: roles
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  permissions :jsonb
#

class RoleSerializer < ApplicationSerializer
  attributes :id, :name, :description, :permissions
end
