module DeviseRequestHelper
  def sign_in_as(staff)
    rest_sign_in staff.email, staff.password
  end

  def sign_in_with(email, password)
    rest_sign_in email, password
  end

  # Assume logins are via JSON
  def rest_sign_in(email, password)
    post '/api/v1/staff/sign_in.json', staff: { email: email, password: password }
  end
end

RSpec.configure do |config|
  config.include DeviseRequestHelper, type: :request
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
end
