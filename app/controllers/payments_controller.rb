class PaymentsController < ApplicationController
  include CartsMixin
  
  #TODO Figure out why I can't just use SslRequirement.disable_ssl_check = true in environment files...
  ssl_required :show, :new, :create, :update unless Rails.env.development? or Rails.env.test?
  before_filter :require_user, :only => [ :index ] 
  before_filter :erase_cart_notice, :only => [ :new, :create, :update ]

  #TODO: Print & Save Receipt
  
  # GET /payments
  def index
    @payments = current_user.payments(:joins => [ :cart, :receipt] , :order => "paid_at DESC")    
  end  

  # GET /payment/new
  def new    
    @cart = current_or_new_cart
    @payment =  @cart.payment || @cart.build_payment

    respond_to do |format|
      format.html # new.haml
      format.xml  { render :xml => @payment }
    end
  end

  # POST /payment
  def create    
    @cart = current_cart   
    if (@payment = @cart.payment)
      @payment.attributes = @payment.attributes.merge!(params[:payment])
    else
      @payment = @cart.build_payment(params[:payment])            
    end 
    @payment.ip_address = request.remote_ip
    @payment.user = current_user if logged_in?
    if @payment.save and @payment.purchase
      flash[:notice] = 'Payment received, thank you.'
      flash[:payment_created] = true # let the next action know that we just created this payment
      clear_cart
      generate_receipt
      render :action => "success"
    else
      render :action => "new"
    end
  end      
  
  # This needs to be here because we allow a user to try to submit a second
  # payment attempt if their transaction is declined.  In that case, the payment
  # is already saved in the DB so form_for will submit to the update action
  # instead of the create action.
  def update
    create
  end  
  
  def erase_cart_notice
    flash[:cart_notice] = nil            
  end
  
  def generate_receipt
    @receipt = @payment.build_receipt
    # debugger
    # FIXME:  The next line is not failing even when the receipt partial can't be run!
    @receipt.body = render_to_string :partial => "payment_receipts/receipt", :locals => { :payment => @payment }     
    @receipt.save!

    # for non-logged-in users, save the receipt ID in a session so they
    # can view it for print.
    session[:visible_receipt_id]= @receipt.id unless logged_in? 
    
    UserMailer.deliver_payment_receipt(@receipt, @payment.display_name)       
  end
  
  def cancel
    current_cart.destroy
    clear_cart
    redirect_to :action => "new"
  end

  include LRDCommerce::PaymentsControllerExtensions
end
