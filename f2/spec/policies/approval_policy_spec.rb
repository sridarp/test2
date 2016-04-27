describe ApprovalPolicy do
  it_should_behave_like 'a project policy subclass', :approval
  subject { ApprovalPolicy }

  permissions :index? do
    it 'allows access for a user' do
      expect(subject).to permit(build_stubbed(:staff))
    end
    it 'allows access for an admin' do
      expect(subject).to permit(build_stubbed(:staff, :admin))
    end
  end

  permissions :create? do
    it 'prevents creation if not an admin' do
      expect(subject).not_to permit(build_stubbed(:staff))
    end
    it 'allows an admin to create approvals' do
      expect(subject).to permit(build_stubbed(:staff, :admin))
    end
  end
end
