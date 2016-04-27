shared_examples_for('a project policy subclass') do |record_symbol|
  %i(show? edit? update? destroy?).each do |permission|
    permissions(permission) do
      it "prevents unassociated users from viewing #{record_symbol}" do
        expect(described_class).not_to permit(build_stubbed(:staff), build_stubbed(record_symbol))
      end

      it "allows you to read #{record_symbol.to_s.pluralize} if one of your group’s roles has the permission for the project" do
        staff = create(:staff)
        project = create(:project)
        Membership.create!(project: project, role: build(:role), group: staff.groups.create)
        record = create(record_symbol, project: project)

        expect(described_class).to permit(staff, record)
      end

      it "disallows on related #{record_symbol} with insufficient permissions" do
        staff = create(:staff)
        project = create(:project)
        Membership.create!(project: project, role: build(:role, permissions: {}), group: staff.groups.create)
        record = create(record_symbol, project: project)

        expect(described_class).not_to permit(staff, record)
      end

      it "allows an admin to access any #{record_symbol}" do
        expect(described_class).to permit(build_stubbed(:staff, :admin), build_stubbed(record_symbol))
      end
    end
  end
end
