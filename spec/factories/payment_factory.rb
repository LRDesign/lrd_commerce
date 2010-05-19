Factory.define :payment do |py|
  py.address_1 "1600 Pennsylvania Ave"
  py.city  "Washington"
  py.state "DC"  
  py.cc_expiration Date.today + 5.years
  py.cc_number '1'
  py.cc_type 'bogus'
  py.cc_verification '123'
  py.first_name "john"
  py.last_name "doe"  
  py.zip '11111'
  py.email 'john@doe.com'
end