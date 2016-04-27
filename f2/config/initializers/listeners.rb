require 'wisper'

Rails.application.config.to_prepare do
  Wisper.clear if Rails.env.development?
  Wisper::GlobalListeners.subscribe(SMTPListener.new)
end
