class LrdCommerceMigrationsGenerator < Rails::Generator::Base
  def manifest
    record do |manifest|
      manifest.migration_template "migrations/create_ecommerce_tables.rb.erb", "db/migrate", :migration_file_name => "create_ecommerce_tables"
    end
  end
end
