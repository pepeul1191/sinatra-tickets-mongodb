use('tickets');

db.getCollection('issues').aggregate([
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
      tags_ids: 1
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
  {
    $project: {
      _id: 1,
      tags: 1
    }
  }
]);
