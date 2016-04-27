# == Schema Information
#
# Table name: roles
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  permissions :jsonb
#

require 'rails_helper'

describe Role do
  describe 'permissions validation' do
    it 'is valid for expected permissions schemes' do
      expect(Role.new(permissions: { 'projects' => %w(read write) })).to be_valid
      expect(Role.new(permissions: nil)).to be_valid
      expect(Role.new(permissions: {})).to be_valid
    end

    it 'adds an error for disallowed models' do
      role = Role.new(permissions: { 'nope' => %w(read) })
      expect(role).to be_invalid
      expect(role.errors[:permissions]).to include("can only include permissions for #{Role::PERMISSIONS.to_sentence}.")
    end

    it 'adds an error for actions besides read/write' do
      role = Role.new(permissions: { 'projects' => %w(approve) })
      expect(role).to be_invalid
      expect(role.errors[:permissions]).to include('can only include "read" and "write" values for each key.')
    end

    it 'adds an error for empty actions' do
      role = Role.new(permissions: { 'projects' => [] })
      expect(role).to be_invalid
      expect(role.errors[:permissions]).to include('can not contain empty permissions values.')
    end
  end
end
