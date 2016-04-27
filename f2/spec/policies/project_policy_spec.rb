describe ProjectPolicy do
  subject { ProjectPolicy }

  permissions :index? do
    it 'allows access for a user' do
      expect(subject).to permit(build_stubbed(:staff))
    end

    it 'allows access for an admin' do
      expect(subject).to permit(build_stubbed(:staff, :admin))
    end
  end

  permissions :create? do
    it 'prevents user without group' do
      expect(subject).not_to permit(build_stubbed(:staff))
    end

    it 'allows creation if staff belongs to at least one group' do
      staff = build_stubbed(:staff)
      staff.groups.build

      expect(subject).to permit(staff)
    end

    it 'allows an admin without a group to build_stubbed projects' do
      expect(subject).to permit(build_stubbed(:staff, :admin))
    end
  end

  %i(show? edit? update? destroy?).each do |permission|
    permissions(permission) do
      it 'prevents unassociated users from viewing projects' do
        expect(subject).not_to permit(build_stubbed(:staff), build_stubbed(:project))
      end

      it 'allows you to read projects if one of your group’s roles has the permission' do
        staff = create(:staff)
        project = create(:project)
        Membership.create!(project: project, role: build(:role), group: staff.groups.create)

        expect(subject).to permit(staff, project)
      end

      it 'disallows on related project with insufficient permissions' do
        staff = create(:staff)
        project = create(:project)
        Membership.create!(project: project, role: build(:role, permissions: {}), group: staff.groups.create)

        expect(subject).not_to permit(staff, project)
      end

      it 'allows an admin to see any project' do
        expect(subject).to permit(build_stubbed(:staff, :admin), build_stubbed(:project))
      end
    end
  end
end
