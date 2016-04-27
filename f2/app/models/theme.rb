# == Schema Information
#
# Table name: themes
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  name        :string
#  description :text
#  config      :json
#

class Theme < ActiveRecord::Base
  CONFIG_SCHEMA = {
    'type': 'object',
    '$schema': 'http://json-schema.org/draft-04/schema',
    'properties': {
      'global': {
        'type': 'array',
        'items': {
          'type': 'object'
        },
        'uniqueItems': true
      },
      'link': {
        'type': 'array',
        'items': {
          'type': 'object'
        },
        'uniqueItems': true
      },
      'button': {
        'type': 'array',
        'items': {
          'type': 'object'
        },
        'uniqueItems': true
      },
      'navigation': {
        'type': 'array',
        'items': {
          'type': 'object'
        },
        'uniqueItems': true
      },
      'region': {
        'type': 'array',
        'items': {
          'type': 'object'
        },
        'uniqueItems': true
      },
      'tables': {
        'type': 'array',
        'items': {
          'type': 'object'
        },
        'uniqueItems': true
      },
      'tags': {
        'type': 'array',
        'items': {
          'type': 'object'
        },
        'uniqueItems': true
      },
      'modal': {
        'type': 'array',
        'items': {
          'type': 'object'
        },
        'uniqueItems': true
      }
    },
    'required': %w(global link button navigation region tables tags modal)
  }.freeze

  validates :name, presence: true
  validates :description, presence: true
  validates :config, presence: true, json: { schema: CONFIG_SCHEMA }
end
