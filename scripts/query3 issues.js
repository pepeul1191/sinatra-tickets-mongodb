use('tickets');

db.getCollection('issues').aggregate([
  // Convertir tags_ids a ObjectId[] si son strings
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
  // Proyección inicial con campos clave
  {
    $project: {
      _id: { $toString: "$_id" },
      resume: 1,
      priority_id: 1,
      reporter_id: 1,
      issue_state_id: 1,
      tags_ids: 1,
      reportered: {
        $dateToString: {
          format: "%Y-%m-%d %H:%M:%S",
          date: "$reportered"
        }
      }
    }
  },
  // Lookup a prioridades
  {
    $lookup: {
      from: "priorities",
      localField: "priority_id",
      foreignField: "_id",
      as: "priority"
    }
  },
  // Lookup a empleados
  {
    $lookup: {
      from: "employees",
      localField: "reporter_id",
      foreignField: "_id",
      as: "reporter"
    }
  },
  // Lookup a estados
  {
    $lookup: {
      from: "issue_states",
      localField: "issue_state_id",
      foreignField: "_id",
      as: "issue_state"
    }
  },
  // Lookup a tags por array
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
  // Unwind de relaciones uno-a-uno
  { $unwind: "$priority" },
  { $unwind: "$reporter" },
  { $unwind: "$issue_state" },
  // Proyección final
  {
    $project: {
      _id: 1,
      resume: 1,
      reportered: 1,
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
      tags: 1
    }
  }
]);
