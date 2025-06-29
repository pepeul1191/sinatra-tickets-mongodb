class IssueController < ApplicationController
  before do
    public_routes = ['/roles']
    unless public_routes.include?(request.path_info) 
      #check_session_true
    end
  end

  post '/api/v1/issues' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      request_body = JSON.parse(request.body.read)
      issue = Issue.new
      issue.name = request_body['name']
      issue.description = request_body['description']
      issue.issue_state_id = BSON::ObjectId(request_body['issue_state_id'])
      issue.priority_id = BSON::ObjectId(request_body['priority_id'])
      issue.reportered = BSON::ObjectId(request_body['reportered'])
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
      issue.histories = []
      issue.documents = []
      issue.created = Time.now
      issue.updated = Time.now
      issue.save
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
      document.name = request_body['name']
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
