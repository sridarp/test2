# == Schema Information
#
# Table name: roles
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  permissions :jsonb
#

class Role < ActiveRecord::Base
  PERMISSIONS = %w(projects approvals memberships).freeze

  has_many :memberships
  has_many :projects, through: :memberships

  validate :permissions_format_is_correct, if: :permissions

  def permissions_format_is_correct
    all_valid_keys
    all_valid_values
    no_empty_values
  end

  def all_valid_keys
    unless permissions.keys & PERMISSIONS == permissions.keys
      errors.add(:permissions, "can only include permissions for #{PERMISSIONS.to_sentence}.")
    end
  end

  def all_valid_values
    unless permissions.values.all? { |perms| perms & %w(read write) == perms }
      errors.add(:permissions, 'can only include "read" and "write" values for each key.')
    end
  end

  def no_empty_values
    unless permissions.values.all?(&:present?)
      errors.add(:permissions, 'can not contain empty permissions values.')
    end
  end
end
