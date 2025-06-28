module Helpers
  def css(csss, constants)
    puts 'csssssssssssssss'
    static_url = constants[:static_url]
    resp = ''
    if defined? csss
      csss.each do |file|
        temp = '<link href="' + static_url + file + '.css" rel="stylesheet"/>'
        resp = resp + temp
      end
    end
    resp
  end

  def js(jss = nil, constants)
    puts 'jssssssssssssss'
    static_url = constants[:static_url]
    resp = ''
    if jss != nil
      if defined? jss
        jss.each do |file|
          temp = '<script src="' + static_url + file + '.js" type="text/javascript"></script>'
          resp = resp + temp
        end
      end
    end
    resp
  end

  def check_session_true
    if session[:logged].nil? || !session[:logged]
      redirect '/login'
    end
  end

  def if_session_true_go_home
    if session[:logged]
      redirect '/'
    end
  end

  def authenticate!
    begin
      auth_header = request.env['HTTP_AUTHORIZATION']
      halt 401, { error: 'Missing Authorization header' }.to_json unless auth_header

      token = auth_header.gsub(/^Bearer\s/, '') # Remueve "Bearer " si está presente

      decoded_token = JWT.decode(token, settings.jwt_secret, true, algorithm: 'HS256')

      # Guardar información del token para usarla en la ruta (opcional)
      @current_user = decoded_token[0]['sub'] # por ejemplo
    rescue JWT::DecodeError => e
      halt 401, { error: 'Invalid token', message: e.message }.to_json
    rescue => e
      halt 500, { error: 'Internal server error', message: e.message }.to_json
    end
  end
end