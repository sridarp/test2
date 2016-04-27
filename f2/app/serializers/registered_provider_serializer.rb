# == Schema Information
#
# Table name: registered_providers
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  deleted_at :datetime
#  type       :string           not null
#  name       :string           not null
#  uuid       :string           not null
#
# Indexes
#
#  index_registered_providers_on_type  (type)
#  index_registered_providers_on_uuid  (uuid)
#

class RegisteredProviderSerializer < ApplicationSerializer
  attributes :id, :uuid, :name, :description, :tags, :questions
end
