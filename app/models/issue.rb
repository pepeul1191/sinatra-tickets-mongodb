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

  def self.summary_list
    Issue.collection.aggregate([
      # Asegura que tags_ids siempre sea array, sin map ni conversión
      {
        '$addFields' => {
          'tags_ids' => { '$ifNull' => ['$tags_ids', []] }
        }
      },
      {
        '$project' => {
          '_id' => { '$toString' => '$_id' },
          'resume' => 1,
          'priority_id' => 1,
          'reporter_id' => 1,
          'issue_state_id' => 1,
          'tags_ids' => 1,
          'reportered' => {
            '$dateToString' => {
              'format' => '%Y-%m-%d %H:%M:%S',
              'date' => '$reportered'
            }
          }
        }
      },
      {
        '$lookup' => {
          'from' => 'priorities',
          'localField' => 'priority_id',
          'foreignField' => '_id',
          'as' => 'priority'
        }
      },
      {
        '$lookup' => {
          'from' => 'employees',
          'localField' => 'reporter_id',
          'foreignField' => '_id',
          'as' => 'reporter'
        }
      },
      {
        '$lookup' => {
          'from' => 'issue_states',
          'localField' => 'issue_state_id',
          'foreignField' => '_id',
          'as' => 'issue_state'
        }
      },
      {
        '$lookup' => {
          'from' => 'tags',
          'let' => { 'tagIds' => '$tags_ids' },
          'pipeline' => [
            {
              '$match' => {
                '$expr' => { '$in' => ['$_id', '$$tagIds'] }
              }
            },
            {
              '$project' => {
                '_id' => { '$toString' => '$_id' },
                'name' => 1
              }
            }
          ],
          'as' => 'tags'
        }
      },
      { '$unwind' => '$priority' },
      { '$unwind' => '$reporter' },
      { '$unwind' => '$issue_state' },
      {
        '$project' => {
          '_id' => 1,
          'resume' => 1,
          'reportered' => 1,
          'priority' => {
            '_id' => { '$toString' => '$priority._id' },
            'name' => '$priority.name'
          },
          'reporter' => {
            '_id' => { '$toString' => '$reporter._id' },
            'name' => {
              '$concat' => ['$reporter.names', ' ', '$reporter.last_names']
            }
          },
          'issue_state' => {
            '_id' => { '$toString' => '$issue_state._id' },
            'name' => '$issue_state.name'
          },
          'tags' => 1
        }
      }
    ])
  end  

  def self.find_one(issue_id)
    Issue.collection.aggregate([
      # 1. Filtro por _id (ObjectId)
      { '$match' => { '_id' => BSON::ObjectId(issue_id) } },
  
      # 2. Garantiza que tags_ids exista como array (pero no convierte nada)
      {
        '$addFields' => {
          'tags_ids' => { '$ifNull' => ['$tags_ids', []] }
        }
      },
  
      # 3. Proyección inicial
      {
        '$project' => {
          '_id' => { '$toString' => '$_id' },
          'resume' => 1,
          'description' => 1,
          'priority_id' => 1,
          'reporter_id' => 1,
          'issue_state_id' => 1,
          'tags_ids' => 1,
          'reportered' => {
            '$dateToString' => {
              'format' => '%Y-%m-%d %H:%M:%S',
              'date' => '$reportered'
            }
          }
        }
      },
  
      # 4. Lookups (igual que antes)
      {
        '$lookup' => {
          'from' => 'priorities',
          'localField' => 'priority_id',
          'foreignField' => '_id',
          'as' => 'priority'
        }
      },
      {
        '$lookup' => {
          'from' => 'employees',
          'localField' => 'reporter_id',
          'foreignField' => '_id',
          'as' => 'reporter'
        }
      },
      {
        '$lookup' => {
          'from' => 'issue_states',
          'localField' => 'issue_state_id',
          'foreignField' => '_id',
          'as' => 'issue_state'
        }
      },
      {
        '$lookup' => {
          'from' => 'tags',
          'let' => { 'tagIds' => '$tags_ids' },
          'pipeline' => [
            {
              '$match' => {
                '$expr' => {
                  '$in' => ['$_id', '$$tagIds']
                }
              }
            },
            {
              '$project' => {
                '_id' => { '$toString' => '$_id' },
                'name' => 1
              }
            }
          ],
          'as' => 'tags'
        }
      },
  
      # 5. Unwind y proyección final
      { '$unwind' => '$priority' },
      { '$unwind' => '$reporter' },
      { '$unwind' => '$issue_state' },
      {
        '$project' => {
          '_id' => 1,
          'resume' => 1,
          'description' => 1,
          'reportered' => 1,
          'priority' => {
            '_id' => { '$toString' => '$priority._id' },
            'name' => '$priority.name'
          },
          'reporter' => {
            '_id' => { '$toString' => '$reporter._id' },
            'name' => {
              '$concat' => ['$reporter.names', ' ', '$reporter.last_names']
            }
          },
          'issue_state' => {
            '_id' => { '$toString' => '$issue_state._id' },
            'name' => '$issue_state.name'
          },
          'tags' => 1
        }
      }
    ]).first
  end  
end
