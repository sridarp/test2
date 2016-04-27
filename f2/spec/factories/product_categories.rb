# == Schema Information
#
# Table name: product_categories
#
#  id              :integer          not null, primary key
#  name            :string
#  description     :string
#  img             :string
#  cached_tag_list :string
#  deleted_at      :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

FactoryGirl.define do
  TAGS = %w(foo bar foobar fizz buzz fizzbuzz doo dad doodad wid get widget).freeze

  factory :product_category do
    sequence :name do |n|
      "Product Category Name #{n}"
    end
    sequence :description do |n|
      "Product Category description #{n}"
    end
    img 'product.png'
    tag_list { TAGS.sample rand 0..(TAGS.length / 2) }
  end
end
