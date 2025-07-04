class HistoryController < ApplicationController
  before do
    public_routes = ['/roles']
    unless public_routes.include?(request.path_info) 
      #check_session_true
    end
  end

  post '/api/v1/histories/:_id/documents' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      history_id = params[:_id]
      request_body = JSON.parse(request.body.read)
      history = History.find(history_id)
      if history then
        # create document
        document = Document.new 
        document.name = request_body['name']
        document.description = request_body['description']
        document.url = request_body['url']
        document.mime = request_body['mime']
        document.created = Time.now
        # update history
        history.documents << document.as_json
        history.updated = Time.now
        history.save
        response = {
          _id: history.id.to_s
        }
      else
        response = {
          message: 'Historia no existe',
          error: 'Ocurrió un error agregar el documento a la historia'
        }
      end
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace
      response = {
        message: 'Ocurrió un error agregar el documento a la historia',
        error: e.message
      }
    end
    # response
    status status
    halt response.to_json
  end

  delete '/api/v1/histories/:_id/documents/:document_id' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      history_id = params[:_id]
      document_id = params[:document_id]
      # add to history
      history = History.find(history_id)
      original_count = history.documents.count
      history.documents = history.documents.reject { |doc| doc["_id"] == document_id }
      if history.documents.count == original_count
        status = 404
        response = { message: "Documento no encontrado en la historia", "error": "No se encontró #{document_id} en historia" }
      else
        history.updated = Time.now
        history.save
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
end
