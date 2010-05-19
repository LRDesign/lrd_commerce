require File.join(File.dirname(__FILE__), '..', 'spec_helper') #Required for plugins

describe CartsController do

  ############################################################################
  ## PUT UPDATE
  ############################################################################
  describe "PUT 'update'" do
    describe "when a cart exists" do
      before(:each) do
        @cart = Factory(:cart)
        session[:current_cart] = @cart.id     
        @controller.current_or_new_cart.should == @cart
      end

      describe "successful action" do
        before(:each) { put :update, :cart => {} }

        it "should succeed" do
          response.should be_success
        end                         
        it "should assign the current cart" do
          assigns[:cart].should == @cart 
        end           
        it "should re-render the edit page" do
          response.should render_template(:edit)
        end
      end    
      
      describe "when the checkout button is clicked" do
        it "should redirect to the payments page" do
          put :update, :commit => "Checkout" 
          response.should redirect_to(new_payment_path)
        end
      end
      
      describe "item creation" do
        it "should add an item to the cart" do
          @prod = Factory(:product, :price => 30)      
          put :update, :cart => { :items_attributes => 
            [ {:product => @prod, :quantity => 2} ] 
          }                               
          assigns[:cart].items.should have(1).item
        end 
        
        it "should not add an item for an invalid product to the cart" do
          put :update, :cart => { :items_attributes => 
            [ {:product_id => 9999, :quantity => 2} ] 
          }                                           
          assigns[:cart].items.should have(0).items          
        end
        it "should not add an item for an unavailable product to the cart" do
          @prod = Factory(:product, :price => 30, :available => false)      
          put :update, :cart => { :items_attributes => 
            [ {:product => @prod, :quantity => 2} ] 
          }                               
          assigns[:cart].items.should have(0).item          
        end                                             
        it "should set the item's price to the product's price" do
          @prod = Factory(:product, :price => 30)      
          put :update, :cart => { :items_attributes => 
            [ {:product => @prod, :quantity => 2, :price => 20} ] 
          }                               
          assigns[:cart].items[0].price.should == 30          
        end
        it "should add an item to the cart when specified by name" do
          @prod = Factory(:product, :price => 30, :name => "Perfect Intonation 1.0")      
          put :update, :product_name => "Perfect Intonation"
          assigns[:cart].items.should have(1).item                          
          assigns[:cart].items[0].product.should == @prod          
        end             
      end  
    end

    describe "when a cart does not exist" do
      before(:each) do
        session[:current_cart] = nil          
      end                            
      it "should create a new cart in the DB" do
        lambda{ put :update, :cart => {} }.should change(Cart, :count).by(1)
      end
      describe "successful action" do
        before(:each) { put :update, :cart => {} }
        it "should description" do
          assigns[:cart].should be_a(Cart)
        end
      end
    end
  end

  ############################################################################
  ## GET EDIT
  ############################################################################
  describe "GET 'edit'" do
    describe "when a cart exists" do
      before(:each) do
        @cart = Factory(:cart)
        session[:current_cart] = @cart.id     
        @controller.current_or_new_cart.should == @cart
      end

      describe "successful action" do
        before(:each) { get :edit }

        it "should succeed" do
          response.should be_success
        end                         
        it "should assign the current cart" do
          assigns[:cart].should == @cart 
        end        
      end
    end  

    describe "when a cart does not exist" do
      before(:each) do
        session[:current_cart] = nil          
      end                            
      it "should create a new cart in the DB" do
        lambda{ get :edit }.should change(Cart, :count).by(1)
      end
      describe "successful action" do
        before(:each) { get :edit }
        it "should description" do
          assigns[:cart].should be_a(Cart)
        end
      end
    end
  end

  ############################################################################
  ## GET SHOW
  ############################################################################
  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should redirect_to(edit_cart_path)
    end
  end
end
