# == Schema Information
#
# Table name: answers
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  answerable_id   :integer          not null
#  answerable_type :string           not null
#  name            :string           not null
#  value           :text
#  value_type      :integer
#
# Indexes
#
#  index_answers_on_answerable_type_and_answerable_id  (answerable_type,answerable_id)
#

FactoryGirl.define do
  factory :answer do
    sequence :name do |n|
      "answer_#{n}"
    end

    answerable_id 1
    answerable_type 'Mock'

    value 'foobar'
    value_type :string

    trait :integer do
      value 1
      value_type :integer
    end

    trait :email do
      value 'foo@bar.com'
      value_type :email
    end

    trait :url do
      value 'http://foobar.com'
      value_type :url
    end
  end
end
