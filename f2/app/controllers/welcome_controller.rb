class WelcomeController < ApplicationController
  skip_before_action :require_user
  def index
    render file: "#{Rails.root}/app/views/site/index"
  end
end
