Factory.define :cart do |cart|
  cart.paid :false
end

Factory.define :cart_item do |cart_item|
  cart_item.product {|prod| prod.association(:product, :price => 1000)}
  cart_item.quantity    1
end
