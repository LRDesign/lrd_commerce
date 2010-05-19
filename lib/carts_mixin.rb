# Contains methods to find and create shopping carts, used by multiple
# controllers that need to place things into shopping carts.
module CartsMixin
        
  class CartAlreadyExists < Exception
  end
              
  # Return the user's current cart, pulled alternately from session
  # or from the user's record as necessary        
  
  # TODO:  this should not find carts that are already paid for!
  def current_cart    
    return Cart.find(session[:current_cart]) if session[:current_cart]      
    return Cart.find_by_user_id(current_user.id) if logged_in?        
  rescue ActiveRecord::RecordNotFound 
    clear_cart
    nil    
  end          
         
  # Create and return a new shopping cart, saving the ID in session
  def create_cart 
    raise CartAlreadyExists if current_cart
    @cart = Cart.create()
    session[:current_cart] = @cart.id
    if logged_in?
      @cart.user = current_user
      @cart.save
    end
    @cart
  end      

  def clear_cart
    session[:current_cart] = nil   
  end                           
  
  def current_or_new_cart
    current_cart or create_cart
  end      
  
  def assign_to_cart_and_save(item) 
    item.cart = current_or_new_cart
    item.save! 
  end
  
end                                                         

