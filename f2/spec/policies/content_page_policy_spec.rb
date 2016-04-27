describe ContentPagePolicy do
  subject { ContentPagePolicy }

  let(:content_page) { create :content_page }
  let(:current_staff) { create :staff }
  let(:admin) { create :staff, :admin }

  permissions :index? do
    it 'allows access for a user' do
      expect(subject).to permit(current_staff)
    end
    it 'allows access for an admin' do
      expect(subject).to permit(admin)
    end
  end

  permissions :show? do
    it 'allows users to view content pages' do
      expect(subject).to permit(current_staff, content_page)
    end
    it 'allows an admin to see any content page' do
      expect(subject).to permit(admin, content_page)
    end
  end

  permissions :create? do
    it 'prevents creation if not an admin' do
      expect(subject).not_to permit(current_staff)
    end
    it 'allows an admin to create content pages' do
      expect(subject).to permit(admin)
    end
  end

  permissions :update? do
    it 'does not allow users to update content pages' do
      expect(subject).not_to permit(current_staff, content_page)
    end
    it 'allows an admin to make updates' do
      expect(subject).to permit(admin, content_page)
    end
  end

  permissions :destroy? do
    it 'does not allow users to delete content pages' do
      expect(subject).to_not permit(current_staff, content_page)
    end
    it 'allows an admin to delete any content page' do
      expect(subject).to permit(admin, content_page)
    end
  end
end
