{
  Setting => :load_defaults,
  ProductType => :load_product_types,
  RegisteredProvider => :load_registered_providers
}.each do |klass, loader|
  next unless klass.table_exists?
  Dir[Rails.root.join 'app', 'models', klass.name.underscore, '*.rb'].each do |model|
    require_dependency model
  end
  klass.descendants.each(&loader)
end

# Include demo support code in development
if Rails.env.development?
  Dir[Rails.root.join 'app', 'models', 'null', '*.rb'].each do |null_model|
    require_dependency null_model
  end
end
