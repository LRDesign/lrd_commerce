# == Schema Information
#
# Table name: carts
#
#  id         :integer(4)      not null, primary key
#  paid       :boolean(1)      default(FALSE)
#  user_id_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Cart < ActiveRecord::Base     
  belongs_to  :user
  has_many  :items, :class_name => "CartItem", :dependent => :destroy
  has_one  :payment, :dependent => :destroy      
  

  named_scope :paid,   :conditions => { :paid => true }
  named_scope :unpaid, :conditions => { :paid => false }
       
  def price
    items.inject(0){ |sum, ci| sum += ci.subtotal }
  end  

  def contains?(product)
    items.each do |i|
      return i if i.product == product
    end
    return false
  end

  attr_accessible :items_attributes
  
  accepts_nested_attributes_for :items, :allow_destroy => true       
end

