class CreateEcommerceTables < ActiveRecord::Migration
  def self.up
    create_table :cart_items do |t|
      t.references  :cart
      t.references  :product
      t.integer     :quantity  
      t.string      :description
      t.decimal     :price,     :precision => 10, :scale => 2
      t.timestamps
    end    
    add_index   :cart_items, :cart_id
    add_index   :cart_items, :product_id
        
    create_table :carts do |t|
      t.boolean :paid,  :nil => false,  :default => false  
      t.references :user    # optional user ID.
      t.timestamps
    end           
    add_index   :carts, :paid
    
    create_table :payments do |t|
      t.references :cart  
      t.references :user                     
      t.string    :first_name
      t.string    :last_name
      t.string    :email
      t.string    :registration_name
      t.string    :ip_address
      t.integer   :amount
      t.string    :payment_method
      t.date      :cc_expiration
      t.string    :cc_type  
      t.string    :address_1
      t.string    :address_2
      t.string    :city
      t.string    :state
      t.string    :country
      t.string    :zip      
      t.datetime  :paid_at
      t.timestamps            
    end           
    add_index   :payments, :cart_id  
    
    
    create_table :payment_receipts do |t|
      t.text        :body
      t.references  :payment
      t.timestamps
    end                     
    add_index    :payment_receipts, :payment_id
    
    create_table :payment_transactions do |t|
      t.references  :payment
      t.string      :action
      t.integer     :amount
      t.boolean     :success
      t.string      :authorization
      t.string      :message
      t.text        :params
      t.timestamps
    end
    add_index   :payment_transactions, :payment_id
    
  end
  def self.down
    drop_table :cart_items    
    drop_table :carts 
    drop_table :payments
    drop_table :payment_receipts
    drop_table :payment_transactions
  end
end
