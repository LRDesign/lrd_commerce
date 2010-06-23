# == Schema Information
# Schema version: 20100321195021
#
# Table name: cart_items
#
#  id          :integer(4)      not null, primary key
#  cart_id     :integer(4)
#  product_id  :integer(4)
#  quantity    :integer(4)
#  description :string(255)
#  price       :decimal(10, 2)
#  created_at  :datetime
#  updated_at  :datetime
#

class CartItem < ActiveRecord::Base
  belongs_to :cart
  belongs_to :product 
  
  attr_accessible :quantity, :product

  named_scope :unavailable, :joins => :product,
    :conditions => ['products.available = ?', false]

  def after_initialize            
    if self.product
      self.price = self.product.price
      self.description = self.product.name
      self.quantity ||= 1
    end
  end

  def subtotal
    self.price * self.quantity    
  end
  
  def paid?
    cart.paid?
  end  
  
end
