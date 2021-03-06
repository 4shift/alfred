# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.assets.paths << "#{Rails.root}/vendor/assets/*"
Rails.application.config.assets.paths << "#{Rails.root}/vendor/assets/fonts"
Rails.application.config.assets.paths << "#{Rails.root}/vendor/assets/stylesheets"

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( application-print.css chat.js users.js alfred-plugin.js brimir-plugin.css landing.css )
Rails.application.config.assets.precompile << Proc.new { |path|
  if path =~ /\.(eot|svg|ttf|woff|otf)\z/
    true
  end
}
