class LrdCommerceViewsGenerator < Rails::Generator::Base
  include UseThor

  def manifest
    build_thor do
      def make_directories
        FileUtils::mkdir_p("app/views/payments")
      end

      def create_payments_new
        template 'payments/new.html.haml.erb', 'app/views/payments/new.html.haml'
      end
    end
  end
end
