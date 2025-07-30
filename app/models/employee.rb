require 'mongoid'

class Employee
  include Mongoid::Document
  field :names, type: String
  field :last_names, type: String
  field :image_url, type: String
  field :user_id, type: Integer
  field :created, type: DateTime
  field :updated, type: DateTime

  def as_json(options = {})
    super(options.merge(except: :_id)).tap do |json|
      json["_id"] = self._id.to_s
    end
  end
end