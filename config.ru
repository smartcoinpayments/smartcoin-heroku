require 'rubygems'
require 'sinatra'
require 'smartcoin'
require 'rack/cors' 

use Rack::Cors do 
	allow do 
		origins '*'  #configure a host
		resource '*', headers: :any, methods: [:get, :post, :options]
	end 
end

require './lib/checkout.rb'
run Sinatra::Application