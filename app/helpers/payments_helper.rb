module PaymentsHelper

  def card_type_selector(form)
    form.select(:cc_type, CREDIT_CARD_TYPES, { :include_blank => true }, { :id => 'cc_type_select' })    
  end              
  
  def card_expiration(form)
    form.date_select :cc_expiration, :discard_day => true,
      :start_year => Date.today.year,    
      :end_year => (Date.today.year+10), 
      :add_month_numbers => true,        
      :order => [ :month, :year ]                
  end         
  
  # Should show a teaser if the current cart
  #   1) Contains an event registration
  #   2) Does not contain a membership application
  #   3) the user is not a member
  #   4) The cart would be cheaper if the user were a member
  def show_discount_teaser?(cart)
    return false if cart.event_registrations.blank?
    return false if current_user.current_member?
    return false unless cart.membership_applications.blank?
    cart.event_registrations.any? { |reg| reg.cost > reg.member_cost }   
  end                            
  
  
  def item_description(item)
    item.description
  end                                             
  
  def indent(content)
    content_tag(:span, content, :style => "padding-left: 2em")    
    # content
  end
               
  def brief_description(payment)
    descs = []
    descs << "Software Purchase" 
    descs.join(", ")
  end 
  
end