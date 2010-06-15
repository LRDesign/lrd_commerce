class CartItemsController < ApplicationController    
  include CartsMixin    
  before_filter :assign_cart

  def create
    @product = Product.find(params[:cart_item][:product_id])
    @cart_item = @cart.items.create(:product => @product)
    if @cart_item.save!
      flash[:notice] = "#{@product.name} added to cart."
    else
      flash[:error] = "Error adding item to cart."
    end

    redirect_to :back
  end

  def index
    redirect_to edit_cart_path 
  end

  def show
    redirect_to edit_cart_path
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    item_name = @cart_item.product.name.html_safe!
    if @cart.items.exists?(@cart_item) && @cart_item.destroy
      flash[:notice] = "#{item_name} removed from cart."
    else
      flash[:error] = "Error removing item from cart."
    end

    redirect_to :back
  end
  
  private
  def assign_cart
    @cart = current_or_new_cart    
  end
end
