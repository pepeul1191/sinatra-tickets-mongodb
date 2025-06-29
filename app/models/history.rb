require 'mongoid'

class History
  include Mongoid::Document
  field :description, type: String
  field :reportered, type: BSON::ObjectId
  field :created, type: DateTime, default: -> { Time.now }
  field :updated, type: DateTime

  def as_json(options = {})
    super(options.merge(except: :_id)).tap do |json|
      json["_id"] = self._id.to_s
    end
  end
end
