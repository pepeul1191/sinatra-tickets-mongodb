class IssueStateController < ApplicationController
  before do
    public_routes = ['/roles']
    unless public_routes.include?(request.path_info) 
      #check_session_true
    end
  end

  get '/api/v1/issue-states' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      issue_states = IssueState.all.to_a
      response = issue_states
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

  post '/api/v1/issue-states' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      request_body = JSON.parse(request.body.read)
      name = request_body['name']
      issue_state = IssueState.new
      issue_state.name = name
      issue_state.created = Time.now
      issue_state.updated = Time.now
      issue_state.save
      response = {
        _id: issue_state.id.to_s
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

  put '/api/v1/issue-states/:_id' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      _id = params[:_id]
      request_body = JSON.parse(request.body.read)
      issue_state = IssueState.find(_id)
      if issue_state 
        issue_state.name = request_body['name']
        issue_state.updated = Time.now
        issue_state.save
        response = {
          _id: issue_state.id.to_s
        }
      else
        status = 404
        response = {
          message: 'Etiqueta a editar no existe',
          error: '_id no existe en issue-states'
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

  delete '/api/v1/issue-states/:_id' do
    # request
    response = {}
    status = 200
    # blogic
    begin
      _id = params[:_id]
      issue_state = IssueState.find(_id)
      if issue_state 
        issue_state.destroy
        response = {
          _id: _id
        }
      else
        status = 404
        response = {
          message: 'Etiqueta a eliminar no existe',
          error: '_id no existe en issue-states'
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