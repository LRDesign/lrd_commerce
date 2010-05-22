class LrdCommerceMailerGenerator < Rails::Generator::Base
  include LrdGeneration::UseThor

  def manifest
    build_thor do 
      argument :domain, :type => :string, :default => "example.com"
      argument :company_name, :type => :string, :default => "My Company, Inc."

      def create_model
        template 'models/user_mailer.rb.erb', 'app/models/user_mailer.rb'
      end

      def create_view
        template 'views/payment_receipt.html.erb.erb', 'app/views/user_mailer/payment_reciept.html.erb'
      end
    end
  end
end
