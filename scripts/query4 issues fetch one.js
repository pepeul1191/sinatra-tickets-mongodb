use('tickets');

db.getCollection('issues').aggregate([
  // Filtro por _id
  {
    $match: {
      _id: ObjectId("686759ace06d833aafeb238d")
    }
  },
  {
    $addFields: {
      tags_ids: {
        $map: {
          input: { $ifNull: ["$tags_ids", []] },
          as: "id",
          in: { $toObjectId: "$$id" }
        }
      }
    }
  },
  {
    $project: {
      _id: { $toString: "$_id" },
      resume: 1,
      description: 1,
      priority_id: 1,
      reporter_id: 1,
      issue_state_id: 1,
      tags_ids: 1,
      documents: 1, // Incluimos documentos para procesarlos luego
      reportered: {
        $dateToString: {
          format: "%Y-%m-%d %H:%M:%S",
          date: "$reportered"
        }
      },
      created: {
        $dateToString: {
          format: "%Y-%m-%d %H:%M:%S",
          date: "$created"
        }
      },
      updated: {
        $dateToString: {
          format: "%Y-%m-%d %H:%M:%S",
          date: "$updated"
        }
      }
    }
  },
  // Procesamos el array 'documents' para convertir _id y created
  {
    $addFields: {
      documents: {
        $map: {
          input: "$documents",
          as: "doc",
          in: {
            _id: { $toString: "$$doc._id" },
            name: "$$doc.name",
            description: "$$doc.description",
            url: "$$doc.url",
            mime: "$$doc.mime",
            created: {
              $dateToString: {
                date: "$$doc.created",
                format: "%Y-%m-%dT%H:%M:%S.%LZ"
              }
            }
          }
        }
      }
    }
  },
  {
    $lookup: {
      from: "priorities",
      localField: "priority_id",
      foreignField: "_id",
      as: "priority"
    }
  },
  {
    $lookup: {
      from: "employees",
      localField: "reporter_id",
      foreignField: "_id",
      as: "reporter"
    }
  },
  {
    $lookup: {
      from: "issue_states",
      localField: "issue_state_id",
      foreignField: "_id",
      as: "issue_state"
    }
  },
  {
    $lookup: {
      from: "tags",
      let: { tagIds: "$tags_ids" },
      pipeline: [
        {
          $match: {
            $expr: {
              $in: ["$_id", "$$tagIds"]
            }
          }
        },
        {
          $project: {
            _id: { $toString: "$_id" },
            name: 1
          }
        }
      ],
      as: "tags"
    }
  },
  { $unwind: "$priority" },
  { $unwind: "$reporter" },
  { $unwind: "$issue_state" },
  {
    $project: {
      _id: 1,
      resume: 1,
      description: 1,
      reportered: 1,
      created: 1,
      updated: 1,
      priority: {
        _id: { $toString: "$priority._id" },
        name: "$priority.name"
      },
      reporter: {
        _id: { $toString: "$reporter._id" },
        name: {
          $concat: ["$reporter.names", " ", "$reporter.last_names"]
        }
      },
      issue_state: {
        _id: { $toString: "$issue_state._id" },
        name: "$issue_state.name"
      },
      tags: 1,
      documents: 1
    }
  }
]).next();