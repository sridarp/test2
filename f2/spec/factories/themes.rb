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

FactoryGirl.define do
  factory :theme do
    default_config = {
      global: [{
        type: 'style',
        label: 'Primary Background ',
        selector: 'primary-background',
        rule: 'background-color',
        value: '#EBEBEB'
      }],
      link: [{
        type: 'style',
        label: 'Link Primary ',
        selector: 'link',
        rule: 'color',
        value: '#2464CC'
      }],
      button: [{
        type: 'mixin',
        label: 'Primary Button Text',
        selector: 'button-primary-text',
        rule: 'button-variant',
        value: '#FFFFFF'
      }],
      navigation: [{
        type: 'style',
        label: 'Primary Background ',
        selector: 'nav-primary-background',
        rule: 'background-color',
        value: '#33394D'
      }],
      region: [{
        type: 'style',
        label: 'Header Background ',
        selector: 'region-header-background',
        rule: 'background-color',
        value: '#FFFFFF'
      }],
      tables: [{
        type: 'style',
        label: 'Header Background ',
        selector: 'table-header-background',
        rule: 'background-color',
        value: '#414042'
      }],
      tags: [{
        type: 'style',
        label: 'Primary Background ',
        selector: 'tag-primary-background',
        rule: 'background-color',
        value: '#14855F'
      }],
      modal: [{
        type: 'style',
        label: 'Header Background ',
        selector: 'modal-header-background',
        rule: 'background-color',
        value: '#23A27E'
      }]
    }

    name 'Test Theme'
    description 'This is a description of the test theme'
    config default_config
  end
end
