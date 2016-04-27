require 'yaml'
require_relative 'jellyfish/version'

root = File.expand_path File.join('..', '..'), __FILE__

settings_file = ["settings.#{Rails.env}.yml", 'settings.yml'].find do |file|
  File.exist? File.join(root, 'config', file)
end

SETTINGS = settings_file ? YAML.load_file(File.join(root, 'config', settings_file)) : {}

SETTINGS[:version] = Jellyfish::Version.new

# Load plugin config, if any
Dir[File.join root, 'config', 'settings.d', '*.yml'].each do |f|
  SETTINGS.merge! YAML.load_file f
end
