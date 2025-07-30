class TagController < ApplicationController
  before do
    public_routes = ['/roles']
    unless public_routes.include?(request.path_info) 
      #check_session_true
    end
  end

  get '/api/v0.5/tags' do
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

  get '/api/v1/tags' do
    # request
    response = {}
    status = 200
    
    # Obtener parámetros de consulta
    name = params[:name]
    page = params[:page]
    step = params[:step]
    
    # blogic
    begin
      # Construir la consulta base
      query = Tag.all
      
      # Aplicar filtros usando criterios de Mongoid
      if name && !name.empty?
        query = query.where(:name => /#{Regexp.escape(name)}/i)
      end
      
      # Paginación
      if page && step
        begin
          page_int = Integer(page)
          step_int = Integer(step)
          
          if page_int <= 0 || step_int <= 0
            raise ArgumentError, "Los valores de paginación deben ser mayores a cero"
          end
          
          # Contar total de documentos
          total = query.count
          
          # Calcular offset y limit
          offset = (page_int - 1) * step_int
          assets = query.skip(offset).limit(step_int).to_a
          
          # Calcular páginas totales
          pages = (total.to_f / step_int).ceil
          
          response = {
            list: assets,
            pages: pages,
            total: total,
            offset: offset
          }
        rescue ArgumentError => e
          status = 400
          response = {
            error: "Error al leer los parámetros de la paginación",
            message: e.message
          }
        rescue => e
          puts "Error de paginación: #{e.message}"
          puts e.backtrace
          status = 500
          response = {
            error: "Error al procesar la paginación",
            message: e.message
          }
        end
      else
        # Sin paginación - devolver todos los resultados
        assets = query.to_a
        response = assets
      end
      
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace
      status = 500
      response = {
        message: 'Ocurrió un error al listar los assets',
        error: e.message
      }
    end
    
    # response
    content_type :json
    status status
    halt response.to_json
  end

  get '/api/v1/tags/:_id' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      _id = params[:_id]
      tag = Tag.where(id: _id).first
      if tag 
        response = tag
      else
        status = 404
        response = {
          message: 'Etiqueta a obtener no existe',
          error: '_id no existe en priorities'
        }
      end
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace
      response = {
        message: 'Ocurrió un error obtener la etiqueta',
        error: e.message
      }
    end
    # response
    content_type :json
    status status
    halt response.to_json
  end

  post '/api/v1/tags' do
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
      response = tag
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

  put '/api/v1/tags/:_id' do
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
        response = tag
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

  delete '/api/v1/tags/:_id' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      _id = params[:_id]
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