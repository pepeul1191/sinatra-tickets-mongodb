class TagApi < ApplicationController
  before do
    public_routes = ['/roles']
    unless public_routes.include?(request.path_info) 
      #check_session_true
    end
  end

  get '/apis/v1/tags' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      tags = Tag.all.to_a
      response = tags
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

  post '/apis/v1/tags' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      request_body = JSON.parse(request.body.read)
      name = request_body['name']
      tag = Tag.new
      tag.name = name
      tag.created = Time.now
      tag.updated = Time.now
      tag.save
      response = {
        _id: tag.id.to_s
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

  put '/apis/v1/tags/:_id' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      _id = params[:_id]
      request_body = JSON.parse(request.body.read)
      tag = Tag.find(_id)
      if tag 
        tag.name = request_body['name']
        tag.updated = Time.now
        tag.save
        response = {
          _id: tag.id.to_s
        }
      else
        status = 404
        response = {
          message: 'Etiqueta a editar no existe',
          error: '_id no existe en tags'
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

  delete '/apis/v1/tags/:_id' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      _id = params[:_id]
      request_body = JSON.parse(request.body.read)
      tag = Tag.find(_id)
      if tag 
        tag.destroy
        response = {
          _id: _id
        }
      else
        status = 404
        response = {
          message: 'Etiqueta a eliminar no existe',
          error: '_id no existe en tags'
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