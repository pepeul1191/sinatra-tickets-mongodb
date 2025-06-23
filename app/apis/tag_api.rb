class TagApi < ApplicationController
  before do
    public_routes = ['/roles']
    unless public_routes.include?(request.path_info) 
      #check_session_true
    end
  end

  get '/apis/v1/tags' do
    'hola'
  end
end