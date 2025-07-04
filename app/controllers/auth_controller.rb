class AuthController < ApplicationController
  before do
    public_routes = ['/roles']
    unless public_routes.include?(request.path_info) 
      #check_session_true
    end
  end

  post '/api/v1/auth/generate-token' do
    incoming_auth = request.env['HTTP_X_AUTH_TRIGGER']
    request_body = JSON.parse(request.body.read)
    """ body:
    'user': {
      'id': answer['body']['id'],
      'username': answer['body']['username'],
      'email':answer['body']['email'],
    }
    """
    # puts "Incoming X-Auth-Trigger: #{incoming_auth}"
    # puts "Expected AUTH_HEADER: #{settings.auth_header}"
    if incoming_auth == settings.auth_header
      user_id = request_body['user']['id']
      # validar si user_id le pertence a un empleado, sino, error
      employee = Employee.where(user_id: user_id).first
      if employee 
        puts "Authentication successful. Generating JWT."
        claims = {
          iss: 'your-app.com',
          aud: 'your-client-id',
          sub: 'user@example.com',
          exp: Time.now.to_i + 3600, # 1 hora
          iat: Time.now.to_i,
          user: request_body['user'],
          employee: {
            _id: employee._id.to_s,
            names: employee.names,
            last_names: employee.last_names,
          },
          role: 'admin'
        }
      else
        halt 404, { 
          error: "Empleado con user_id #{user_id} no le pertenece a ningun empleado",
          message: 'Empleado no registrado', 
        }.to_json
      end
      # si existe empleado, continuar
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

  get '/api/v1/auth/token-info' do
    begin
      { 
        user: @current_user, 
        employee: @current_employee, 
      }.to_json
    rescue JWT::DecodeError => e
      halt 401, { error: 'Invalid token', message: e.message }.to_json
    end
  end
end