require 'sinatra/base'

class ApplicationController < Sinatra::Base
  # Habilitar logging
  configure :development, :production do
    enable :logging
  end

  enable :sessions # Habilitar sesiones

  configure do
    set :session_secret, 'a4b89e6d2f4c7b98334f5e2c1e93460b2f94b24a6c9e5d073c44d4e69e839485'
    set :sessions, expire_after: 3600
    set :views, File.expand_path('../../views', __FILE__)
    set :public_folder, File.expand_path('../../../public', __FILE__)
    set :constants, CONSTANTS[:local]
  end

  before do
    env["rack.logger"] = Logger.new(STDOUT)
  end

  helpers Helpers

  [
    '/', '/sign-out',  
  ].each do |path|
    before path do
      check_session_true
    end
  end

  not_found do
    # Lista de extensiones de archivos estáticos que no deben devolver un 404 con un ERB
    static_extensions = %w[css js png jpg gif svg ico woff woff2 ttf eot mp4 webm]
    
    # Obtener la extensión del archivo de la URL (sin el punto)
    ext = File.extname(request.path).delete_prefix('.')
    
    # Solo procesar si NO es un archivo estático
    unless static_extensions.include?(ext)
      if request.get?
        status 404
        erb :'application/not_found', 
            layout: :'layouts/blank',
            locals: { title: 'Recurso no encontrado' }
      else
        content_type :json
        status 404
        { 
          message: 'Recurso no encontrado', 
          error: "#{request.request_method} #{request.path} no existe"
        }.to_json
      end
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
