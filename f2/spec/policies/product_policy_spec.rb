describe ProductPolicy do
  permissions :index? do
    it 'allows access for a user' do
      expect(ProductPolicy).to permit(current_staff)
    end
  end

  permissions :show? do
    it 'allows access for a user' do
      expect(ProductPolicy).to permit(current_staff)
    end
  end

  %i(new? create? update? destroy?).each do |action|
    permissions action do
      it 'disallows a staff' do
        expect(ProductPolicy).not_to permit(current_staff)
      end

      it 'allows an admin' do
        expect(ProductPolicy).to permit(admin)
      end
    end
  end

  def admin
    create(:staff, :admin)
  end

  def current_staff
    create(:staff)
  end
end
