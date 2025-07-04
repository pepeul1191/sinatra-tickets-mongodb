require 'mongoid'

class Track
  include Mongoid::Document
  field :issue_id, type: BSON::ObjectId
  field :documents, type: Array, default: [], as: :documents

  embeds_many :logs

  def as_json(options = {})
    super(options.merge(except: :_id)).tap do |json|
      json["_id"] = self._id.to_s
    end
  end
end