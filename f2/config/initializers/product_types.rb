# require 'json'
# require 'null_provisioner'
#
# Dir.glob(Rails.root.join('config', 'product_questions', '*.json')) do |filename|
#   Rails.application.config.x.product_types.merge!(JSON.parse(File.read(filename)))
# end
# Rails.application.config.x.provisioners.merge!(
#   JSON.parse(File.read(Rails.root.join('config', 'provisioners.json')))
#     .map { |product_type, provisioner| [product_type, provisioner.constantize] }.to_h
# )
