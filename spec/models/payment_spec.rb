# == Schema Information
# Schema version: 20100321195021
#
# Table name: payments
#
#  id                :integer(4)      not null, primary key
#  cart_id           :integer(4)
#  user_id           :integer(4)
#  first_name        :string(255)
#  last_name         :string(255)
#  email             :string(255)
#  registration_name :string(255)
#  ip_address        :string(255)
#  amount            :integer(4)
#  payment_method    :string(255)
#  cc_expiration     :date
#  cc_type           :string(255)
#  address_1         :string(255)
#  address_2         :string(255)
#  city              :string(255)
#  state             :string(255)
#  country           :string(255)
#  zip               :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

require File.join(File.dirname(__FILE__), '../spec_helper')

describe Payment do
  before(:each) do
    @payment = Factory(:payment)
  end

  it "should be valid" do
    @payment.should be_valid
  end
  
  describe "display_name" do
    it "should return the display name of an associated user" do
      @payment.user = Factory(:payment_user)
      @payment.display_name.should == @payment.user.display_name             
    end
  end
 
end
