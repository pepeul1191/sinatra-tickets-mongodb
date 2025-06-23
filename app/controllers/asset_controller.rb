class AssetController < ApplicationController
  before do
    public_routes = ['/roles']
    unless public_routes.include?(request.path_info) 
      #check_session_true
    end
  end

  get '/apis/v1/assets' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      assets = Asset.all.to_a
      response = assets
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

  post '/apis/v1/assets' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      request_body = JSON.parse(request.body.read)
      asset = Asset.new
      asset.name = request_body['name']
      asset.description = request_body['description']
      asset.created = Time.now
      asset.updated = Time.now
      asset.save
      response = {
        _id: asset.id.to_s
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

  put '/apis/v1/assets/:_id' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      _id = params[:_id]
      request_body = JSON.parse(request.body.read)
      asset = Asset.find(_id)
      if asset 
        asset.name = request_body['name']
        asset.description = request_body['description']
        asset.updated = Time.now
        asset.save
        response = {
          _id: asset.id.to_s
        }
      else
        status = 404
        response = {
          message: 'Etiqueta a editar no existe',
          error: '_id no existe en asset'
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

  delete '/apis/v1/assets/:_id' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      _id = params[:_id]
      asset = Asset.find(_id)
      if asset 
        asset.destroy
        response = {
          _id: _id
        }
      else
        status = 404
        response = {
          message: 'Etiqueta a eliminar no existe',
          error: '_id no existe en asset'
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