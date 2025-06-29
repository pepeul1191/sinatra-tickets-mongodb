require 'mongoid'

class Priority
  include Mongoid::Document
  field :name, type: String
  field :created, type: DateTime
  field :updated, type: DateTime

  def as_json(options = {})
    super(options.merge(except: :_id)).tap do |json|
      json["_id"] = self._id.to_s
    end
  end
end