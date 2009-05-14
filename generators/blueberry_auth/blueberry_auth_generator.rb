class BlueberryAuthGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      # Add User model
      m.directory File.join('app', 'models')
      m.file 'user_model.rb', 'app/models/user.rb'

      # Add User factory
      m.directory File.join('test', 'factories')
      m.file 'factory.rb', 'test/factories/users.rb'
 
      # Add User migration file
      m.migration_template 'create_users_migration.rb', 'db/migrate',
        :migration_file_name => 'create_users'
        
      # Add site key
      m.file 'auth_site_key.rb', 'config/initializers/auth_site_key.rb'
      
      # Add Authentication mixin to application controller
      m.gsub_file 'app/controllers/application_controller.rb', /^(class|module) .+$/ do |match|
        "#{match}\n  include Authentication"
      end
    end
  end
end