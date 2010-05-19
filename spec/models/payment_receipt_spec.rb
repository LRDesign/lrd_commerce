# == Schema Information
# Schema version: 20100321195021
#
# Table name: payment_receipts
#
#  id         :integer(4)      not null, primary key
#  body       :text
#  payment_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe PaymentReceipt do
  before(:each) do
    @valid_attributes = {
      :body => "value for body",
      :payment_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    PaymentReceipt.create!(@valid_attributes)
  end
end
