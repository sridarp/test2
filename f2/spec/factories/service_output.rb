FactoryGirl.define do
  factory :service_output do
    sequence :name do |n|
      "service_attribute_#{n}"
    end

    service

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
