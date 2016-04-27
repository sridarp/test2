describe 'routing' do
  it 'routes to glob urls' do
    expect(get: '/admin/test').to route_to(
      controller: 'welcome',
      action: 'index',
      path: 'admin/test'
    )
  end

  describe 'checks if page exists' do
    before :each do
      allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new('production'))
    end

    it 'should not give a 404' do
      expect(get: '/').to be_routable
    end
  end
end
