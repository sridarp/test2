require 'spec_helper'

describe MembershipPolicy do
  it_should_behave_like 'a project policy subclass', :membership
end
