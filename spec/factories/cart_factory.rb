Factory.define :cart do |cart|
  cart.paid :false
end

Factory.define :cart_item do |cart_item|
  cart_item.association :product
  cart_item.quantity    1
end
