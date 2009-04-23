class BlueberryAuthGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      # Add User model
      m.directory File.join("app", "models")
      m.file "user_model.rb", "app/models/user.rb"
 
      # Add User migration file
      m.migration_template "create_users_migration.rb", 'db/migrate',
        :migration_file_name => "create_users"
    end
  end
end