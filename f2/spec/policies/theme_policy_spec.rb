describe ThemePolicy do
  subject { ThemePolicy }

  let(:current_staff) { create :staff }
  let(:admin) { create :staff, :admin }

  permissions :update? do
    it 'prevents updates if not an admin' do
      expect(subject).not_to permit(current_staff)
    end
    it 'allows an admin to make updates' do
      expect(subject).to permit(admin)
    end
  end
end
