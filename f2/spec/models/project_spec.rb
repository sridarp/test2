# == Schema Information
#
# Table name: projects
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  description    :text
#  img            :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  deleted_at     :datetime
#  status         :integer          default(0)
#  archived       :datetime
#  spent          :decimal(12, 2)   default(0.0)
#  budget         :decimal(12, 2)   default(0.0)
#  start_date     :datetime
#  end_date       :datetime
#  health         :integer
#  monthly_spend  :decimal(12, 2)   default(0.0)
#  monthly_budget :decimal(12, 2)   default(0.0)
#
# Indexes
#
#  index_projects_on_archived    (archived)
#  index_projects_on_deleted_at  (deleted_at)
#

describe 'Project.compute_current_status!' do
  it 'sets project status to highest priority service alert status' do
    staff = create :staff, :admin
    project = create :project

    project.orders << create(:order,
      project: project,
      staff: staff,
      services: [create(:service,
        alerts: [
          create(:alert, status: :ok),
          high_priority_alert = create(:alert, status: :critical)
        ]
      )]
    )
    project.orders << create(:order,
      project: project,
      staff: staff,
      services: [create(:service,
        alerts: [
          create(:alert, status: :warning),
          create(:alert, status: :warning)
        ]
      )]
    )

    project.reload.compute_current_status!
    expect(project.health).to eq(high_priority_alert.status)
  end

  it 'sets project health to ok if project has no services' do
    project = create(:project)
    project.compute_current_status!
    expect(project.health).to eq('ok')
  end
end

describe 'Project.problem_count' do
  it 'returns count of non-ok latest alerts for a project' do
    project = create :project

    project.orders << create(:order,
      project: project,
      services: [create(:service,
        alerts: [
          create(:alert, status: :ok),
          create(:alert, status: :critical)
        ]
      )]
    )

    project.orders << create(:order,
      project: project,
      services: [create(:service,
        alerts: [
          create(:alert, status: :warning),
          create(:alert, status: :ok)
        ]
      )]
    )

    expect(project.problem_count).to eq(1)
  end
end

describe 'Project.monthly_spend' do
  it 'returns total monthly spend' do
    user = create :staff
    project = create :project, status: :approved, monthly_budget: 1000
    product = create :product, monthly_price: 1.0

    CreateServiceOrder.perform user,
      project_id: project.id,
      products: [
        {
          product_id: product.id,
          service: { 'name' => 'Service 1' }
        }
      ]

    CreateServiceOrder.perform user,
      project_id: project.id,
      products: [{
        product_id: product.id,
        service: { 'name' => 'Service 2' }
      }]
    project.reload

    expect(project.monthly_spend).to be_a BigDecimal
    expect(project.monthly_spend).to eq 2.0
  end
end

describe 'Project.monthly_budget' do
  before(:each) do
    @user = create :staff
    @project = create :project, status: :approved, monthly_budget: 100
  end

  it 'denies new orders that exceed the monthly budget' do
    @product = create :product, monthly_price: 150

    expect do
      CreateServiceOrder.perform @user,
        project_id: @project.id,
        products: [{
          product_id: @product.id,
          service: { 'name' => 'Service 1' }
        }]
    end .to raise_error CreateServiceOrder::BudgetError
  end

  it 'allows new orders that stay within the monthly budget' do
    @product = create :product, monthly_price: 100

    CreateServiceOrder.perform @user,
      project_id: @project.id,
      products: [{
        product_id: @product.id,
        service: { 'name' => 'Service 1' }
      }]
    @project.reload

    expect(@project.services.length).to eq 1
  end

  it 'allows new orders with multiple services that stay within the monthly budget' do
    @product_one = create :product, monthly_price: 50
    @product_two = create :product, monthly_price: 25

    CreateServiceOrder.perform @user,
      project_id: @project.id,
      products: [{
        product_id: @product_one.id,
        service: { 'name' => 'Service 1' }
      }, {
        product_id: @product_two.id,
        service: { 'name' => 'Service 2' }
      }]
    @project.reload

    expect(@project.services.length).to eq 2
  end

  it 'rejects new orders with multiple services that exceed the monthly budget' do
    @product_one = create :product, monthly_price: 50
    @product_two = create :product, monthly_price: 75

    expect do
      CreateServiceOrder.perform @user,
        project_id: @project.id,
        products: [{
          product_id: @product_one.id,
          service: { 'name' => 'Service 1' }
        }, {
          product_id: @product_two.id,
          service: { 'name' => 'Service 2' }
        }]
      @project.reload
    end .to raise_error CreateServiceOrder::BudgetError
  end

  it 'rejects new orders with multiple identical services that exceed the monthly budget' do
    @product_one = create :product, monthly_price: 20
    @product_two = create :product, monthly_price: 75

    expect do
      CreateServiceOrder.perform @user,
        project_id: @project.id,
        products: [{
          product_id: @product_one.id,
          service: { 'name' => 'Service 1' }
        }, {
          product_id: @product_two.id,
          service: { 'name' => 'Service 2' }
        }, {
          product_id: @product_one.id,
          service: { 'name' => 'Service 3' }
        }]
      @project.reload
    end .to raise_error CreateServiceOrder::BudgetError
  end
end
