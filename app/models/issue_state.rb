require 'mongoid'

class IssueState
  include Mongoid::Document
  field :name, type: String
  field :created, type: DateTime, default: -> { Time.now }
  field :updated, type: DateTime

  def as_json(options = {})
    super(options.merge(except: :_id)).tap do |json|
      json["id"] = self._id.to_s
    end
  end
end