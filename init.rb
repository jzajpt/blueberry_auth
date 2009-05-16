# Add locales
# I18n.load_path += Dir[Rails.root.join('vendor', 'plugins', 'blueberry_auth', 'config', 'locales', '*.yml')]
I18n.load_path << Dir[File.expand_path(File.dirname(__FILE__) + '/config/locales/*.yml')]

require 'blueberry_auth'

