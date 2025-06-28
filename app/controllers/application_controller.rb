require 'sinatra/base'
require 'jwt'
require 'json'
require 'dotenv/load'
require 'sinatra/cross_origin'
require 'sinatra/cors'

class ApplicationController < Sinatra::Base
  # Habilitar logging
  configure :development, :production do
    enable :logging
    enable :cross_origin
  end

  enable :sessions # Habilitar sesiones

  configure do
    set :session_secret, 'a4b89e6d2f4c7b98334f5e2c1e93460b2f94b24a6c9e5d073c44d4e69e839485'
    set :sessions, expire_after: 3600
    set :views, File.expand_path('../../views', __FILE__)
    set :public_folder, File.expand_path('../../../public', __FILE__)
    set :constants, CONSTANTS[:local]
    set :auth_header, ENV['HTTP_X_AUTH_TRIGGER']
    set :jwt_secret, ENV['JWT_SECRET']
  end

  before do
    env["rack.logger"] = Logger.new(STDOUT)
  end

  before '/api/v1/*' do
    request_method = request.request_method
    public_routes = [
      '/api/v1/auth/generate-token'
    ]
    unless public_routes.include?(request.path_info)
      if %w[GET POST PUT DELETE].include?(request_method)
        authenticate!
        content_type :json
      end
    end
  end

  # Manejo de preflight (OPTIONS)
  options '/api/v1/*' do
    # No necesitas autenticación aquí
    response.headers['Access-Control-Allow-Origin'] = 'http://localhost:8000'
    response.headers['Access-Control-Allow-Credentials'] = 'true'
    response.headers['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Content-Type, Authorization'
    200
  end

  helpers Helpers

  [
    '/', '/sign-out',  
  ].each do |path|
    before path do
      check_session_true
    end
  end

  post '/api/v1/auth/generate-token' do
    incoming_auth = request.env['HTTP_X_AUTH_TRIGGER']
    # puts "Incoming X-Auth-Trigger: #{incoming_auth}"
    # puts "Expected AUTH_HEADER: #{settings.auth_header}"
    if incoming_auth == settings.auth_header
      puts "Authentication successful. Generating JWT."
      claims = {
        iss: 'your-app.com',
        aud: 'your-client-id',
        sub: 'user@example.com',
        exp: Time.now.to_i + 3600, # 1 hora
        iat: Time.now.to_i,
        user_id: 123,
        role: 'admin'
      }
      begin
        token = JWT.encode claims, settings.jwt_secret, 'HS256'
        { token: token }.to_json
      rescue => e
        puts "Failed to encode JWT: #{e.message}"
        halt 500, { error: 'Failed to generate token' }.to_json
      end
    else
      puts "Unauthorized access attempt. Invalid or missing X-Auth-Trigger."
      status 401
      { error: 'Unauthorized', message: 'Invalid or missing X-Auth-Trigger' }.to_json
    end
  end

  not_found do
    # Lista de extensiones de archivos estáticos que no deben devolver un 404 con un ERB
    static_extensions = %w[css js png jpg gif svg ico woff woff2 ttf eot mp4 webm]
    
    # Obtener la extensión del archivo de la URL (sin el punto)
    ext = File.extname(request.path).delete_prefix('.')
    
    # Solo procesar si NO es un archivo estático
    unless static_extensions.include?(ext)
      content_type :json
      status 404
      { 
        message: 'Recurso no encontrado', 
        error: "#{request.request_method} #{request.path} no existe"
      }.to_json
    end
  end

  get '/' do
    locals = { 
      title: 'Gestión de Accesos', 
    }
    erb :'application/home', layout: :'layouts/application', locals: locals
  end

  get '/sign-out' do
    session.clear
    redirect '/login'
  end
end
