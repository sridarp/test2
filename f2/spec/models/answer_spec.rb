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

require 'rails_helper'

describe Answer do
  it 'has a valid factory' do
    expect(build(:answer)).to be_valid
  end

  it 'inherits from ValueTypes' do
    expect(Answer.ancestors.include?(ValueTypes)).to be true
  end

  describe 'casting' do
    it 'to strings' do
      answer = create :answer, value: 'foobar'
      answer.reload
      expect(answer.value_type).to eq('string')
      expect(answer.value).to eq('foobar')
    end

    it 'to numbers' do
      answer = create :answer, :integer, value: 123
      answer.reload
      expect(answer.value_type).to eq('integer')
      expect(answer.value).to eq(123)
    end

    it 'to emails' do
      answer = create :answer, :email, value: 'foo@bar.com'
      answer.reload
      expect(answer.value_type).to eq('email')
      expect(answer.value).to eq('foo@bar.com')
    end

    it 'to urls' do
      answer = create :answer, :url, value: 'http://foobar.com'
      answer.reload
      expect(answer.value_type).to eq('url')
      expect(answer.value).to eq('http://foobar.com')
    end
  end

  describe 'cast failures thrown' do
    it 'for integer' do
      answer = build :answer, :integer, value: 'foo@bar.com'
      expect { answer.save! }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Value is not a number')
    end

    it 'for emails' do
      answer = build :answer, :email, value: '123 Main St.'
      expect { answer.save! }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Value is not a valid e-mail address')
    end

    it 'for urls' do
      answer = build :answer, :url, value: 123
      expect { answer.save! }.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Value must be a valid URI')
    end
  end
end
