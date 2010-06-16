require File.join(File.dirname(__FILE__), '..', 'spec_helper') #Required for plugins

describe CartItemsController do
  before(:each) do
    # set back URL
    @back = @request.env['HTTP_REFERER'] = 'http://foo'
    @cart = Factory(:cart)
    session[:current_cart] = @cart.id
  end

  ##################################################################
  ## POST CREATE
  ##################################################################
  describe "POST 'create'" do
    describe "with a valid product ID" do
      before(:each) do
        @product = Factory(:product)
      end

      it "should create the cart item" do
        post 'create', :cart_item => { :product_id => @product.id }
        assigns[:cart_item].should_not be_nil
        assigns[:cart_item].product.id.should == @product.id
      end

      it "should redirect back" do
        post 'create', :cart_item => { :product_id => @product.id }
        response.should redirect_to(@back)
      end

      it "should set flash for item added to cart" do
        post 'create', :cart_item => { :product_id => @product.id }
        flash[:notice].should == "#{@product.name} added to cart."
      end
    end

    describe "with a bad a product ID" do
      it "should not create/assign the cart item" do
        post 'create', :cart_item => { :product_id => -1 }
        assigns[:cart_item].should be_nil
      end

      it "should redirect back" do
        post 'create', :cart_item => { :product_id => -1 }
        response.should redirect_to(@back)
      end

      it "should set flash for failure" do
        post 'create', :cart_item => { :product_id => -1 }
        flash[:error].should == "Error adding item to cart."
      end
    end
  end

  ##################################################################
  ## GET SHOW, GET INDEX
  ##################################################################
  describe "GET 'show', GET 'index'" do
    it "should redirect to cart" do
      item = @cart.items.create(:product => Factory(:product))
      get 'show', :id => item.id 
      response.should redirect_to(edit_cart_path)
      get 'index'
      response.should redirect_to(edit_cart_path)
    end
  end
end
