post '/' do
	SmartCoin.api_key('pk_test_407d1f51a61756')
  SmartCoin.api_secret('sk_test_86e4486a0078b2')

  charge = SmartCoin::Charge.create(params)
  
  #do something like:
  # if charge.paid
  #   #confirm the purchase
  # else
  #   #cancel the purchase
  # end

  charge.to_json
end

get '/ping' do
  'It\'s alive!'
end