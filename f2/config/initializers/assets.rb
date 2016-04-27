# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = (ENV['ASSETS_VERSION'] || '1.0')

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile.shift
Rails.application.config.assets.precompile += %w( libraries.js libraries.css )
Rails.application.config.assets.precompile.unshift(proc do |path, filename|
  filename.start_with?(Rails.root.join('app/assets').to_s) && !%w(.js .css .html .svg).include?(File.extname(path))
end)

Rails.application.config.assets.precompile += %w( .svg .png .jpg .gif)

# Skip compiling anything other than .js or .css files
# Rails.application.config.assets.precompile.delete Sprockets::Railtie::LOOSE_APP_ASSETS

# Use a path other than /assets for the compiled assets
Rails.application.config.assets.prefix = '/frontend'
