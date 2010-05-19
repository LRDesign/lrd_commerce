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

class Payment < ActiveRecord::Base
  belongs_to :cart 
  belongs_to :user     
  has_one  :receipt, :class_name => "PaymentReceipt", :dependent => :destroy
  has_many :transactions, :class_name => "PaymentTransaction", :dependent => :destroy
  attr_accessor :cc_number, :cc_verification   
  attr_accessible :cc_number, :cc_verification, :cc_expiration, :cc_type,
    :address_1, :address_2, :city, :state, :country, :zip, :first_name, :last_name,
    :registration_name, :payment_method, :email

  named_scope :paid, :conditions => "paid_at IS NOT NULL"
    
  attr_human_name :cc_type => "Card Type"
  attr_human_name :cc_number => "Card Number"
  attr_human_name :cc_expiration => "Exp. Date"
  attr_human_name :cc_verification => "Security Code"
  attr_human_name :address_1 => "Address Line 1"
  attr_human_name :registration_name => "Name"

  validate_on_create :validate_card                
  validates_presence_of :first_name, :last_name, :address_1, :city, :state, :zip, :email

  def purchase                  
    response = GATEWAY.authorize(price_in_cents, credit_card, purchase_options)
    transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
    if response.success?
      cart.update_attribute(:paid, true)
      self.update_attribute(:paid_at, Time.now)
      self.update_attribute(:amount, price_in_cents)  
    end
    response.success?
  end              
  
  def price_in_cents
    (cart.price*100).round
  end


  def purchase_options
    {
      :ip => ip_address,
      :billing_address => {
        :name     => name,
        :address1 => address_1,
        :city     => city,
        :state    => state,
        :country  => country,
        :zip      => zip
      }
    }
  end

  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add_to_base message
      end
    end
  end    

  def name
    "#{first_name} last_name"
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :type               => cc_type,
      :number             => cc_number,
      :verification_value => cc_verification,
      :month              => cc_expiration.month,
      :year               => cc_expiration.year,
      :first_name         => first_name,
      :last_name          => last_name
    )
  end

  def display_name          
    if self.user.blank?
      "#{self.first_name} #{self.last_name}"
    else
      self.user.display_name
    end   
  end    
end
