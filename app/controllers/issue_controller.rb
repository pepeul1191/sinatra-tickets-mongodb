class IssueController < ApplicationController
  before do
    public_routes = ['/roles']
    unless public_routes.include?(request.path_info) 
      #check_session_true
    end
  end

  post '/apis/v1/issues' do
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
end
