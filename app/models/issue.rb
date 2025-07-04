require 'mongoid'

class Issue
  include Mongoid::Document
  field :resume, type: String
  field :description, type: String
  field :issue_state_id, type: BSON::ObjectId
  field :priority_id, type: BSON::ObjectId
  field :reporter_id, type: BSON::ObjectId
  field :reportered, type: DateTime
  field :assets_ids, type: Array, default: [], as: :assets_ids
  field :tags_ids, type: Array, default: [], as: :tags_ids
  field :visors_ids, type: Array, default: [], as: :visors_ids
  field :editors_ids, type: Array, default: [], as: :editors_ids
  field :histories, type: Array, default: [], as: :histories
  field :documents, type: Array, default: [], as: :documents
  field :created, type: DateTime, default: -> { Time.now }
  field :updated, type: DateTime

  def as_json(options = {})
    super(options.merge(except: :_id)).tap do |json|
      json["_id"] = self._id.to_s
    end
  end
end
