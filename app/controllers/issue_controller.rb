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

  get '/api/v1/issues/summary' do
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

  delete '/apis/v1/issues/:_id' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      _id = params[:_id]
      issue = Issue.find(_id)
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
      document.resume = request_body['resume']
      document.description = request_body['description']
      document.url = request_body['url']
      document.mime = request_body['mime']
      document.created = Time.now
      # add to issue
      issue = Issue.find(issue_id)
      issue.documents << document.as_json
      issue.updated = Time.now
      issue.save
      response = {
        _id: issue.id.to_s
      }
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
      issue.documents = issue.documents.reject { |doc| doc["_id"] == document_id }
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
