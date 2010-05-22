class LrdCommerceMailerGenerator < Rails::Generator::Base
  include LrdGeneration::UseThor

  def manifest
    build_thor do 
      argument :domain, :type => :string, :default => "example.com"
      argument :company_name, :type => :string, :default => "My Company, Inc."

      def create_user_mailer
        template 'user_mailer.rb.erb', 'app/models/user_mailer.rb'
      end
    end
  end
end
