class PriorityController < ApplicationController
  before do
    public_routes = ['/roles']
    unless public_routes.include?(request.path_info) 
      #check_session_true
    end
  end

  get '/api/v1/priorities' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      prioritys = Priority.all.to_a
      response = prioritys
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace
      response = {
        message: 'Ocurrió un error al listar la etiqueta',
        error: e.message
      }
    end
    # response
    content_type :json
    status status
    halt response.to_json
  end

  get '/api/v1/priorities/:_id' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      _id = params[:_id]
      priority = Priority.where(id: _id).first
      if priority 
        response = priority
      else
        status = 404
        response = {
          message: 'Prioridad a obtener no existe',
          error: '_id no existe en priorities'
        }
      end
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace
      response = {
        message: 'Ocurrió un error obtener la prioridad',
        error: e.message
      }
    end
    # response
    content_type :json
    status status
    halt response.to_json
  end

  post '/api/v1/priorities' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      request_body = JSON.parse(request.body.read)
      name = request_body['name']
      priority = Priority.new
      priority.name = name
      priority.created = Time.now
      priority.updated = Time.now
      priority.save
      response = {
        _id: priority.id.to_s
      }
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace
      response = {
        message: 'Ocurrió un error crear la etiqueta',
        error: e.message
      }
    end
    # response
    content_type :json
    status status
    halt response.to_json
  end

  put '/api/v1/priorities/:_id' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      _id = params[:_id]
      request_body = JSON.parse(request.body.read)
      priority = Priority.find(_id)
      if priority 
        priority.name = request_body['name']
        priority.updated = Time.now
        priority.save
        response = {
          _id: priority.id.to_s
        }
      else
        status = 404
        response = {
          message: 'Etiqueta a editar no existe',
          error: '_id no existe en priority'
        }
      end
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace
      response = {
        message: 'Ocurrió un error actualizar la etiqueta',
        error: e.message
      }
    end
    # response
    content_type :json
    status status
    halt response.to_json
  end

  delete '/api/v1/priorities/:_id' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      _id = params[:_id]
      priority = Priority.find(_id)
      if priority 
        priority.destroy
        response = {
          _id: _id
        }
      else
        status = 404
        response = {
          message: 'Etiqueta a eliminar no existe',
          error: '_id no existe en priority'
        }
      end
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace
      response = {
        message: 'Ocurrió un error borrar la etiqueta',
        error: e.message
      }
    end
    # response
    content_type :json
    status status
    halt response.to_json
  end
end