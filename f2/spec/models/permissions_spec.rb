require 'spec_helper'

describe Permissions do
  it 'permits a user with permission for a model type' do
    staff = create(:staff)
    project = create(:project)
    Membership.create!(project: project, role: create(:role, permissions: { projects: ['write'] }), group: staff.groups.create)

    expect(Permissions.new(user: staff, object: project).allow?('write')).to be true
  end

  it 'denies a user without permission' do
    staff = create(:staff)
    project = create(:project)
    Membership.create!(project: project, role: create(:role, permissions: {}), group: staff.groups.create)

    expect(Permissions.new(user: staff, object: project).allow?('write')).to be false
  end

  it 'throws an exception if object does not have a table_name' do
    expect { Permissions.new(user: build_stubbed(:staff), object: 'no table name') }.to raise_error(ArgumentError)
  end

  it 'throws an exception if object does not have a project' do
    expect { Permissions.new(user: build_stubbed(:staff), object: build_stubbed(:staff)) }.to raise_error(ArgumentError)
  end
end
