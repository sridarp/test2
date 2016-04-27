describe MotdPolicy do
  subject { MotdPolicy }

  let(:motd) { create :motd }
  let(:user) { create :staff, :user }
  let(:admin) { create :staff, :admin }
  let(:guest) { nil }

  permissions :create? do
    it 'prevents creation of an MOTD for a user' do
      expect(subject).not_to permit(user)
    end

    it 'allows creation of an MOTD for an admin' do
      expect(subject).to permit(admin)
    end

    it 'prevents creation of an MOTD for a guest' do
      expect { subject.new(nil, :motd) }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  permissions :update? do
    it 'prevents updates for a user' do
      expect(subject).not_to permit(user)
    end

    it 'allows an admin to make updates' do
      expect(subject).to permit(admin)
    end

    it 'prevents updates for a guest' do
      expect { subject.new(nil, :motd) }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  permissions :destroy? do
    it 'prevents deleting for a user' do
      expect(subject).not_to permit(user)
    end

    it 'allows an admin to delete an MOTD' do
      expect(subject).to permit(admin)
    end

    it 'prevents deleting for a guest' do
      expect { subject.new(nil, :motd) }.to raise_error(Pundit::NotAuthorizedError)
    end
  end
end
