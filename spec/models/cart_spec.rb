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


require 'spec_helper'

describe Cart do
  before(:each) do
    @cart = Factory(:cart)    
    @p1 = Factory(:product, :price => 30.00)
    @p2 = Factory(:product, :price => 25.00)
  end
  
  describe "cart price" do
    it "should be the same as the price for a single cart_item" do
      @cart.items << Factory.build(:cart_item, :product => @p1)
      @cart.price.should == 30
    end
    it "should be the same as the price for a quantity of cart_items" do
      @cart.items << Factory.build(:cart_item, :product => @p1, :quantity => 2)
      @cart.price.should == 60      
    end    
    it "should sum the prices of the cart items" do      
      @cart.items << Factory.build(:cart_item, :product => @p1, :quantity => 2)
      @cart.items << Factory.build(:cart_item, :product => @p2, :quantity => 1)      
      @cart.price.should == 85    
    end
  end

end


