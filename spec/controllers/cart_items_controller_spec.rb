require File.join(File.dirname(__FILE__), '..', 'spec_helper') #Required for plugins

describe CartItemsController do
  before(:each) do
    @cart = Factory(:cart)
    session[:current_cart] = @cart.id
    @item = @cart.items.create(:product => Factory(:product))
  end

  ##################################################################
  ## GET SHOW, GET INDEX
  ##################################################################
  describe "GET 'show', GET 'index'" do
    it "should redirect to cart" do
      get 'show', :id => @item.id 
      response.should redirect_to(edit_cart_path)
      get 'index'
      response.should redirect_to(edit_cart_path)
    end
  end
end
