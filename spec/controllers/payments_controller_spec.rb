require 'spec_helper'

describe PaymentsController, "handling GET /payments" do
  before(:each) {  activate_authlogic } 
  
  describe "while not logged in" do
    before(:each) { logout }
    it "should redirect" do
      get :index
      response.should be_redirect
    end
  end
           
  describe "while logged in" do
    before(:each) do 
      @user = login_as(Factory(:beta_user)) 
      @p1 = Factory(:payment, :user => @user)
      @p2 = Factory(:payment, :user => @user)
      @p_other = Factory(:payment, :user => Factory(:beta_user))
      get :index
    end
    it "should find and assign a list of the user's past payments" do
      assigns[:payments].should include(@p1)
      assigns[:payments].should include(@p2)
    end
    
    it "should not assign a different user's payments" do
      assigns[:payments].should_not include(@p3)      
    end
    
    it "should succeed" do
      response.should be_success
    end
  end        
end

describe PaymentsController, "handling GET /payments/new" do

  before do    
    @cart = Factory(:cart)
    @cart_item = Factory(:cart_item) 
    @cart.items << @cart_item
    @cart.save!
    session[:current_cart] = @cart
    @controller.current_or_new_cart.should == @cart
  end
  
  def do_get
    get :new
  end

  describe "with successful action" do
    before(:each) { do_get }
    it "should be successful" do
      response.should be_success
    end
    it "should render new template" do
      response.should render_template('new')
    end
    it "should create a new payment" do
      assigns[:payment].should be_a(Payment)
    end
    it "should assign the current cart to @cart" do
      assigns[:cart].should == controller.current_cart    
    end                                                   
    
  end
  
  it "should not save the new payment" do
    lambda {do_get}.should_not change(Payment, :count)
  end                 
  
  it "should find a previous payment if one exists" do    
    @payment =  Factory(:payment)
    @cart.payment = @payment
    @cart.save!
    do_get
    assigns[:payment].should == @payment    
  end
  
    
end

describe PaymentsController, "handling POST /payments" do

  before(:each) do  
    @cart = Factory(:cart)
    @cart_item = Factory(:cart_item) 
    @cart.items << @cart_item
    @cart.save!
    session[:current_cart] = @cart
    @controller.current_or_new_cart.should == @cart     
  end

  it "success should create a new payment" do
    lambda do
      post :create, :payment => valid_parameters
    end.should change(Payment, :count).by(1)
  end                
  
  it "success should find the old payment record if one already exists" do
    @payment =  Factory(:payment)
    @cart.payment = @payment
    @cart.save!                 
    
    lambda do
      post :create, :payment => valid_parameters
    end.should_not change(Payment, :count)
    assigns[:payment].should == @payment            
  end
  
  it "success should create a new transaction" do     
    lambda do
      post :create, :payment => valid_parameters
    end.should change(PaymentTransaction, :count).by(1)    
  end

  it "should mark the cart paid" do
    lambda do
      post :create, :payment => valid_parameters      
      @cart.reload      
    end.should change{ @cart.paid? }.from(false).to(true)
  end          
  
  it "should set the paid_at date" do
    post :create, :payment => valid_parameters      
    @cart.reload.payment.paid_at.should be_close(Time.now, 2.seconds)
  end             
  
  it "should set the amount in the payment" do
    post :create, :payment => valid_parameters              
    @payment = assigns[:payment]
    @payment.reload.amount.should == (@cart.price*100).round 
  end 
  
  it "should set the ip address in the payment" do
    @request.env['REMOTE_ADDR'] = '123.123.123.123'
    post :create, :payment => valid_parameters              
    assigns[:payment].ip_address.should == '123.123.123.123'
  end

  describe "successful transactions while logged out" do
    before(:each) do
      post :create, :payment => valid_parameters
    end
    
    it "should assign a payment" do
      assigns[:payment].should be_a(Payment)
    end
   
    it "should associate the payment with the current cart" do
      @cart.reload
      assigns[:payment].cart.should == @cart
      @cart.payment.should == assigns[:payment]  
    end       

    it "should redirect to the new payment on successful save" do
      response.should render_template('success')
    end                                  
    
    it "should put all the passed parameters in the new payment object" do
      valid_parameters.keys.each { |k| 
        assigns[:payment].send(k).should == valid_parameters[k]
      }
    end
             
    describe "receipt generation" do
      integrate_views
      it "should associate the payment with a populated receipt" do
        assigns[:payment].receipt.should be_a(PaymentReceipt)
        assigns[:payment].receipt.body.should_not be_nil
      end
    end
        
    it "should clear the current_cart" do      
      session[:current_cart].should be_nil
    end
    
    it "should add the receipt's ID to a session hash" do
      session[:visible_receipt_id].should == assigns[:payment].receipt.id
    end       
  end
  
  describe "logged in" do
    before(:each) do
      activate_authlogic
      login_as @user = Factory(:beta_user)      
    end

    it "should email the receipt to the user" do
      lambda do    
        post :create, :payment => valid_parameters
      end.should change(ActionMailer::Base.deliveries, :length).by(1)        
    end
    
    describe "valid transactions" do
      before(:each) {  post :create, :payment => valid_parameters   }
      
      it "should associate the payment with the current user (if there one)" do
        assigns[:payment].user.should == @user 
        @user.payments.should include(assigns[:payment])
      end          
      it "should not save the receipt id in sessions" do
        session[:visible_receipt_id].should be_nil
      end
    end
  end
  
  describe "non-successful transactions" do
    
    it "should re-render 'new' on failed save" do   
      post :create, :payment => invalid_parameters
      response.should render_template('new')
    end        
  end       
  
  def valid_parameters
    {
      :cc_type => 'bogus',
      :cc_number => '1',
      :cc_verification => '111',
      :cc_expiration => Date.today + 5.years,
      :first_name => 'John',
      :last_name => 'Doe',
      :address_1 => "1600 Pennsylvania Ave. NW",
      :city => "Washington",
      :state => "DC",
      :zip => "20500",
      :email => "john@doe.com"                 
    }
  end   
  
  def invalid_parameters
    valid_parameters.merge!({:cc_number => '2', :first_name => nil})    
  end  
end

describe PaymentsController, "handling GET /cancel" do

  before(:each) do  
    @cart = Factory(:cart)
    @cart_item = Factory(:cart_item) 
    @cart.items << @cart_item
    @cart.save!
    session[:current_cart] = @cart
    @controller.current_or_new_cart.should == @cart    
  end

  it "should clear the current_cart" do      
    post :cancel
    session[:current_cart].should be_nil
  end

  it "should destroy the cart" do     
    lambda do
      post :cancel
    end.should change(Cart, :count).by(-1)    
  end

  it "should destroy the cart_item" do     
    lambda do
      post :cancel
    end.should change(CartItem, :count).by(-1)    
  end

  it "should redirect to the checkout page" do
    post :cancel
    response.should redirect_to(new_payment_path)
  end
end