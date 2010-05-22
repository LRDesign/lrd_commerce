class LrdCommerceViewsGenerator < Rails::Generator::Base
  include LrdGeneration::UseThor

  def manifest
    build_thor do
      def create_payments_new
        template 'payments/new.html.haml.erb', 'app/views/payments/new.html.haml'
      end

      def create_payments_index
        template 'payments/index.html.haml.erb', 'app/views/payments/index.html.haml'
      end

      def create_payments_success
        template 'payments/success.html.haml.erb', 'app/views/payments/success.html.haml'
      end

      def create_carts_edit
        template 'carts/edit.html.haml.erb', 'app/views/carts/edit.html.haml'
      end

      def create_carts_item_partial
        template 'carts/_cart_item.html.haml.erb', 'app/views/carts/_cart_item.html.haml'
      end

      def create_payment_receipts_partial
        template 'payment_receipts/_receipt.html.haml.erb', 'app/views/payment_receipts/_receipt.html.haml'
      end
    end
  end
end
