require 'mongoid'

class Log
  include Mongoid::Document
  field :operation, type: String # create, read, edit, delete
  field :description, type: String # create, read, edit, delete
  field :user_id, type: BSON::ObjectId
  field :created, type: DateTime

  embedded_in :track

  def as_json(options = {})
    super(options.merge(except: :_id)).tap do |json|
      json["_id"] = self._id.to_s
    end
  end
end