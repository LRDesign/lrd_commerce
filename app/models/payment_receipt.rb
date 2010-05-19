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

class PaymentReceipt < ActiveRecord::Base 
  belongs_to :payment

  validates_presence_of :body
  
  attr_accessible :body
end
