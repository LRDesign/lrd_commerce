class CartsController < ApplicationController    
  include CartsMixin    
  before_filter :assign_cart, :only => [:update, :edit]
  
  def update
    @cart.update_attributes(params[:cart])  
    add_named_items     
    reject_invalid_cart_items  
    if params[:commit] =~ /Checkout/
      redirect_to new_payment_path
    else
      render :action => :edit
    end      
  end

  def edit                     
  end

  def show
    redirect_to edit_cart_path
  end

  protected
  # We don't build or accept cart items that point to a nonexistent product.
  # I'm doing this here rather than in a validation, because I don't want
  # existing carts in the DB to become invalid if products get deleted
  # later on.
  def reject_invalid_cart_items
    @cart.items.each do |item|    
      @cart.items.delete(item) unless item.product && item.product.available? 
    end    
  end

  private
  def assign_cart
    @cart = current_or_new_cart    
  end                        
  
  def add_named_items 
    # debugger
    return unless params[:product_name] 
    if @product = Product.available.named(params[:product_name]).first
      @cart.items << CartItem.new(:product => @product, :quantity => 1)
    end
  end

end
