# == Schema Information
# Schema version: 20100321195021
#
# Table name: payment_transactions
#
#  id            :integer(4)      not null, primary key
#  payment_id    :integer(4)
#  action        :string(255)
#  amount        :integer(4)
#  success       :boolean(1)
#  authorization :string(255)
#  message       :string(255)
#  params        :text
#  created_at    :datetime
#  updated_at    :datetime
#

require File.join(File.dirname(__FILE__), '../spec_helper')

describe PaymentTransaction do
  before(:each) do
    @valid_attributes = {
      :payment_id => 1,
      :action => "value for action",
      :amount => 1,
      :success => false,
      :authorization => "value for authorization",
      :message => "value for message",
      :params => "value for params"
    }
  end

  it "should create a new instance given valid attributes" do
    PaymentTransaction.create!(@valid_attributes)
  end
end
