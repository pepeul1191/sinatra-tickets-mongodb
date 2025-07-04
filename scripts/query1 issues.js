use('tickets');

db.getCollection('issues').aggregate([
  {
    $project: {
      _id: { $toString: "$_id" },
      resume: 1,
      priority_id: 1,
      reporter_id: 1,
      issue_state_id: 1,
      reportered: {
        $dateToString: {
          format: "%Y-%m-%d %H:%M:%S",
          date: "$reportered"
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
  { $unwind: "$priority" },
  { $unwind: "$reporter" },
  { $unwind: "$issue_state" },
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
      }
    }
  }
]);
