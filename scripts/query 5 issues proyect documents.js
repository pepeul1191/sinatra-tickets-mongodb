use('tickets');

db.getCollection('issues').aggregate([
  {
    $match: {
      _id: ObjectId("686759ace06d833aafeb238d") // Filtra por el issue deseado
    }
  },
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
                format: "%Y-%m-%dT%H:%M:%S.%LZ" // Formato ISO 8601
              }
            }
          }
        }
      }
    }
  }
])