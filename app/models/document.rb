require 'mongoid'

class Document
  include Mongoid::Document

  embedded_in :issue

  field :name, type: String
  field :description, type: String
  field :url, type: String
  field :mime, type: String
  field :size, type: Integer
  field :created, type: DateTime

  def as_json(options = {})
    super(options.merge(except: :_id)).tap do |json|
      json["_id"] = self._id.to_s
    end
  end
end