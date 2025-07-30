require 'date'

class IssueController < ApplicationController
  before do
    public_routes = ['/roles']
    unless public_routes.include?(request.path_info) 
      #check_session_true
    end
  end

  get '/api/v1/issues' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      issues = Issue.all.to_a
      response = issues
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace
      response = {
        message: 'Ocurrió un error al listar las incidencias',
        error: e.message
      }
    end
    # response
    content_type :json
    status status
    halt response.to_json
  end

  def faltas
    if request_body['assets_ids'] != [] then
      issue.assets_ids = request_body['assets_ids'].map { |id| BSON::ObjectId.from_string(id) }
    end
    if request_body['tags_ids'] != [] then
      issue.tags_ids = request_body['tags_ids'].map { |id| BSON::ObjectId.from_string(id) }
    end
    if request_body['visors_ids'] != [] then
      issue.visors_ids = request_body['visors_ids'].map { |id| BSON::ObjectId.from_string(id) }
    end
    if request_body['editors_ids'] != [] then
      issue.editors_ids = request_body['editors_ids'].map { |id| BSON::ObjectId.from_string(id) }
    end
  end

  get '/api/v0.5/issues/summary' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      issues = Issue.summary_list().to_a
      response = issues
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace
      response = {
        message: 'Ocurrió un error al listar las incidencias',
        error: e.message
      }
    end
    # response
    content_type :json
    status status
    response.to_json
  end

  get '/api/v1/issues/summary' do
    # request
    response = {}
    status = 200
    
    # Obtener parámetros de consulta
    name = params[:name]
    state_id = params[:issueStateId]
    priority_id = params[:priorityId]
    reported_from = params[:initDate] # fecha inferior
    reported_to = params[:endDate]     # fecha superior
    page = params[:page]
    step = params[:step]
    
    # blogic
    begin
      # Construir pipeline base
      pipeline = []
      
      # Etapa de match para filtros
      match_stage = {}
      
      # Filtro por nombre (resume)
      if name && !name.empty?
        match_stage['resume'] = /#{Regexp.escape(name)}/i
      end
      
      # Filtro por estado
      if state_id && !state_id.empty?
        begin
          match_stage['issue_state_id'] = BSON::ObjectId.from_string(state_id)
        rescue BSON::Error::InvalidObjectId
          status = 400
          response = {
            error: "ID de estado inválido",
            message: "El ID de estado proporcionado no es válido"
          }
          raise "Invalid state_id"
        end
      end
      
      # Filtro por prioridad
      if priority_id && !priority_id.empty?
        begin
          match_stage['priority_id'] = BSON::ObjectId.from_string(priority_id)
        rescue BSON::Error::InvalidObjectId
          status = 400
          response = {
            error: "ID de prioridad inválido",
            message: "El ID de prioridad proporcionado no es válido"
          }
          raise "Invalid priority_id"
        end
      end
      
      # Filtros por rango de fechas
      date_conditions = {}
      if reported_from && !reported_from.empty?
        begin
          from_date = DateTime.parse(reported_from)
          date_conditions['$gte'] = from_date
        rescue ArgumentError
          status = 400
          response = {
            error: "Fecha 'reported_from' inválida",
            message: "El formato de fecha debe ser YYYY-MM-DD o YYYY-MM-DD HH:MM:SS"
          }
          raise "Invalid reported_from date"
        end
      end
      
      if reported_to && !reported_to.empty?
        begin
          to_date = DateTime.parse(reported_to)
          date_conditions['$lte'] = to_date
        rescue ArgumentError
          status = 400
          response = {
            error: "Fecha 'reported_to' inválida",
            message: "El formato de fecha debe ser YYYY-MM-DD o YYYY-MM-DD HH:MM:SS"
          }
          raise "Invalid reported_to date"
        end
      end
      
      if date_conditions.any?
        match_stage['reportered'] = date_conditions
      end
      
      # Agregar etapa de match si hay filtros
      unless match_stage.empty?
        pipeline << { '$match' => match_stage }
      end
      
      # Agregar el pipeline de summary_list
      pipeline += Issue.summary_list_pipeline
      
      # Paginación
      if page && step
        begin
          page_int = Integer(page)
          step_int = Integer(step)
          
          if page_int <= 0 || step_int <= 0
            raise ArgumentError, "Los valores de paginación deben ser mayores a cero"
          end
          
          # Para contar total con los mismos filtros, necesitamos ejecutar una consulta separada
          count_pipeline = []
          unless match_stage.empty?
            count_pipeline << { '$match' => match_stage }
          end
          count_pipeline << { '$count' => 'total' }
          
          count_result = Issue.collection.aggregate(count_pipeline).first
          total = count_result ? count_result['total'] : 0
          
          # Agregar skip y limit al pipeline principal
          pipeline << { '$skip' => (page_int - 1) * step_int }
          pipeline << { '$limit' => step_int }
          
          # Ejecutar consulta paginada
          issues = Issue.collection.aggregate(pipeline).to_a
          
          # Calcular páginas totales
          pages = (total.to_f / step_int).ceil
          
          response = {
            list: issues,
            pages: pages,
            total: total,
            offset: (page_int - 1) * step_int
          }
        rescue ArgumentError => e
          status = 400
          response = {
            error: "Error al leer los parámetros de la paginación",
            message: e.message
          }
        rescue => e
          unless response.key?(:error) # Solo si no fue un error ya manejado
            puts "Error de paginación: #{e.message}"
            puts e.backtrace
            status = 500
            response = {
              error: "Error al procesar la paginación",
              message: e.message
            }
          end
        end
      else
        # Sin paginación - devolver todos los resultados
        issues = Issue.collection.aggregate(pipeline).to_a
        response = issues
      end
      
    rescue => e
      # Solo manejar errores no manejados previamente
      if status == 200 # Si no se ha establecido un status de error
        puts "Error: #{e.message}"
        puts e.backtrace
        status = 500
        response = {
          message: 'Ocurrió un error al listar las incidencias',
          error: e.message
        }
      end
    end
    
    # response
    content_type :json
    status status
    halt response.to_json
  end

  get '/api/v1/issues/fetch-one/:_id' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      issues = Issue.find_one(params[:_id])
      puts issues
      response = issues
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace
      response = {
        message: 'Ocurrió un error al listar las incidencias',
        error: e.message
      }
    end
    # response
    content_type :json
    status status
    response.to_json
  end

  def faltas
    if request_body['assets_ids'] != [] then
      issue.assets_ids = request_body['assets_ids'].map { |id| BSON::ObjectId.from_string(id) }
    end
    if request_body['tags_ids'] != [] then
      issue.tags_ids = request_body['tags_ids'].map { |id| BSON::ObjectId.from_string(id) }
    end
    if request_body['visors_ids'] != [] then
      issue.visors_ids = request_body['visors_ids'].map { |id| BSON::ObjectId.from_string(id) }
    end
    if request_body['editors_ids'] != [] then
      issue.editors_ids = request_body['editors_ids'].map { |id| BSON::ObjectId.from_string(id) }
    end
  end

  post '/api/v1/issues' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      request_body = JSON.parse(request.body.read)
      # nuevo Issue
      issue = Issue.new
      issue.resume = request_body['resume']
      issue.description = request_body['description']
      issue.issue_state_id = BSON::ObjectId(request_body['issue_state_id'])
      issue.priority_id = BSON::ObjectId(request_body['priority_id'])
      issue.reporter_id = BSON::ObjectId(request_body['reporter_id'])
      issue.reportered = DateTime.iso8601(request_body['reportered'])
      issue.assets_ids = []
      issue.tags_ids = []
      issue.visors_ids = []
      issue.editors_ids = []
      issue.histories = []
      issue.documents = []
      issue.created = Time.now
      issue.updated = Time.now
      issue.save
      # track de Issue
      log = Log.new
      log.operation = 'create'
      log.description = 'Incidencia creada'
      log.user_id = 'pendiente'
      log.created = Time.now
      track = Track.new
      track.logs << log
      track.save!

      response = {
        _id: issue.id.to_s
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
    status status
    halt response.to_json
  end

  put '/api/v1/issues/:_id' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      request_body = JSON.parse(request.body.read)
      issue_id = params[:_id]

      # Buscar el issue existente
      issue = Issue.where(id: issue_id).first
      raise "Issue no encontrado" unless issue
  
      # Actualizar campos
      issue.resume = request_body['resume']
      issue.description = request_body['description']
      issue.issue_state_id = BSON::ObjectId(request_body['issue_state_id'])
      issue.priority_id = BSON::ObjectId(request_body['priority_id'])
      issue.reporter_id = BSON::ObjectId(request_body['reporter_id'])
      issue.reportered = DateTime.iso8601(request_body['reportered']) rescue nil
      issue.updated = Time.now
  
      issue.save!

      response = {
        _id: issue.id.to_s
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
    status status
    halt response.to_json
  end

  patch '/api/v1/issues/:_id' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      request_body = JSON.parse(request.body.read)
      _id = params[:_id]
      # nuevo Issue
      issue = Issue.find(_id)
      # Reemplazar completamente tags_ids con un nuevo arreglo de ObjectId
      new_tag_ids = request_body.map { |id| BSON::ObjectId(id) }
      issue.tags_ids = new_tag_ids
      issue.updated = Time.now
      issue.save
      # track de Issue
      track = Track.where(issue_id: BSON::ObjectId(_id)).first
      if track
        log = Log.new(
          operation: 'update',
          description: 'Etiquetas actualizadas',
          user_id: @current_user['id'], # asegúrate que sea un ObjectId válido
          created: Time.now
        )
        track.logs << log
        track.save!
      end

      response = {
        _id: issue.id.to_s
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
    status status
    halt response.to_json
  end

  delete '/api/v1/issues/:_id' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      _id = params[:_id]
      issue = Issue.where(id: _id).first
      if issue 
        issue.destroy
        response = {
          _id: _id
        }
      else
        status = 404
        response = {
          message: 'Incidencia a eliminar no existe',
          error: '_id no existe en issue-states'
        }
      end
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace
      response = {
        message: 'Ocurrió un error borrar la incidencia',
        error: e.message
      }
    end
    # response
    content_type :json
    status status
    halt response.to_json
  end

  post '/api/v1/issues/:_id/documents' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      issue_id = params[:_id]
      request_body = JSON.parse(request.body.read)
      # create document
      document = Document.new 
      document.name = request_body['name']
      document.description = request_body['description']
      document.size = request_body['size']
      document.url = request_body['url']
      document.mime = request_body['mime']
      document.created = Time.now
      # add to issue
      issue = Issue.find(issue_id)
      unless issue
        status 404 # Not Found
        return { error: "Issue con ID '#{issue_id}' no encontrado." }.to_json
      end
      issue.documents << document
      issue.updated = Time.now
      issue.save
      response = document
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace
      response = {
        message: 'Ocurrió un error agregar el documento a la incidencia',
        error: e.message
      }
    end
    # response
    status status
    halt response.to_json
  end

  delete '/api/v1/issues/:_id/documents/:document_id' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      issue_id = params[:_id]
      document_id = params[:document_id]
      # add to issue
      issue = Issue.find(issue_id)
      original_count = issue.documents.count
      issue.documents = issue.documents.reject { |doc| doc["_id"] == BSON::ObjectId(document_id) }
      if issue.documents.count == original_count
        status = 404
        response = { message: "Documento no encontrado en la incidencia", "error": "No se encontró #{document_id} en inciencia" }
      else
        issue.updated = Time.now
        issue.save
        response = { message: "Documento eliminado correctamente" }
      end
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace
      response = {
        message: 'Ocurrió un error retirar el documento a la incidencia',
        error: e.message
      }
    end
    # response
    status status
    halt response.to_json
  end

  post '/api/v1/issues/:_id/histories' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      issue_id = params[:_id]
      request_body = JSON.parse(request.body.read)
      # create document
      history = History.new 
      history.reportered = BSON::ObjectId(request_body['reportered'])
      history.description = request_body['description']
      history.created = Time.now
      history.save
      # add to issue
      issue = Issue.find(issue_id)
      issue.histories << history.id
      issue.updated = Time.now
      issue.save
      response = {
        _id: issue.id.to_s,
        history_id: history.id.to_s
      }
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace
      response = {
        message: 'Ocurrió un error agregar historia a la incidencia',
        error: e.message
      }
    end
    # response
    status status
    halt response.to_json
  end
end
