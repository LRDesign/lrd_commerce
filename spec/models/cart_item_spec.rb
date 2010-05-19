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

require File.join(File.dirname(__FILE__), '../spec_helper')

describe CartItem do
  before(:each) do
    @valid_attributes = {
      :cart_id => 1,
      :product_id => 1,
      :quantity => 1
    }
  end

  it "should create a new instance given valid attributes" do
    CartItem.create!(@valid_attributes)
  end
  
  describe "building from a product" do
    before(:each) do
      @product = Factory(:product, :available => true, :price => 30.00, :name => 'foobar product')
      @cart_item = CartItem.new(:product => @product)
    end
    it "should transfer the price" do
      @cart_item.price.should == 30.00
    end    
    it "should default to a quantity of one" do
      @cart_item.quantity.should == 1
    end
    it "should transfer the name to the description" do
      @cart_item.description.should == @product.name
    end
  end
  
  describe "subtotal" do
    it "should be correct" do
      @ci = Factory(:cart_item, :price => 15.00, :quantity => 1)      
      @ci.subtotal.should == 15.00
      @ci.update_attribute(:price, 25.00)
      @ci.subtotal.should == 25.00
      @ci.update_attribute(:quantity, 3)
      @ci.subtotal.should == 75
    end
  end
  
end
