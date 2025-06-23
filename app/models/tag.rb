require 'mongoid'

class Tag
  include Mongoid::Document
  field :name, type: String
  field :created, type: DateTime
  field :updated, type: DateTime

  def as_json(options = {})
    super(options.merge(except: :_id)).tap do |json|
      json["id"] = self._id.to_s
    end
  end
end