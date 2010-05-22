class LrdCommerceViewsGenerator < Rails::Generator::Base
  include LrdGeneration::UseThor

  def manifest
    build_thor do
      def create_payments_new
        template 'payments/new.html.haml.erb', 'app/views/payments/new.html.haml'
      end
    end
  end
end
