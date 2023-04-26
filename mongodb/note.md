# MongoDB

## Create user
```mongodb
use admin
db.createUser(
  {
    user: "dasong",
    pwd: "dasong", // or cleartext password
    roles: [
      { role: "userAdminAnyDatabase", db: "admin" },
      { role: "readWriteAnyDatabase", db: "admin" }
    ]
  }
)
```

## Shutdown
```mongodb
db.adminCommand( { shutdown: 1 } )
```

## Create mongodb with auth
```bash
docker run -d --name mongodb-auth -p 28017:27017 \
-e MONGO_INITDB_ROOT_USERNAME=mongoadmin \
-e MONGO_INITDB_ROOT_PASSWORD=2wsx@WSX \
mongo
```

## Transaction
```mongodb
var session = db.getMongo().startSession()
session.startTransaction()
var test1 = session.getDatabase('test').getCollection('test1')

test1.updateOne({
    name: "marcus_001"
}, {
    $set: {
        age: 38
    }
})
```

## Create mongodb cluster
```bash
docker network create mongoCluster

docker run -d --rm -p 27017:27017 --name mongo1 --network mongoCluster mongo:latest mongod --replSet myReplicaSet --bind_ip localhost,mongo1

docker run -d --rm -p 27018:27017 --name mongo2 --network mongoCluster mongo:latest mongod --replSet myReplicaSet --bind_ip localhost,mongo2

docker run -d --rm -p 27019:27017 --name mongo3 --network mongoCluster mongo:latest mongod --replSet myReplicaSet --bind_ip localhost,mongo3

docker exec -it mongo1 mongosh --eval "rs.initiate({
 _id: \"myReplicaSet\",
 members: [
   {_id: 0, host: \"mongo1\"},
   {_id: 1, host: \"mongo2\"},
   {_id: 2, host: \"mongo3\"}
 ]
})"

docker exec -it mongo1 mongosh --eval "rs.status()"
```

## Data manipulation
```mongodb
db.expenses.findOne({_id: ObjectId("63f93cfad64e2f537ebea5f1")});

db.expenses.updateOne(
    {_id: ObjectId("63f93cfad64e2f537ebea5f1")}, 
    {
      $set: {
        remark: {$concat: ["$remark", "_test2"]}
      }
    }
)

db.expenses.aggregate({
        $set: {
            remark1: "test1"
        }
    }
)

db.expenses.insertMany(
  [
    {
      date: '2021-07-07',
      '$hotel': 320.1,
      phone: 25.17
    }
  ]
)


db.expenses.updateOne(
  {
    _id: ObjectId("63ffb75e2483b8da1f076ea3")}, 
    {$set: {remark: "test"}
  }
)

db.expenses.findAndModify(
  {
    query: {_id: ObjectId("63ffb75e2483b8da1f076ea3")}, 
    update: {remark: "test11"},
  }
)

db.expenses.aggregate(
    {
        $count: "xx"
    }
)

db.expenses.aggregate(
    {
        $group: {_id: "_id", xy: {$count: {}}}
    }
)

db.expenses.aggregate(
    {
        $sum: "$phone"
    }
)

db.students.insertMany(
  [
    {_id: 101001, name: "marcus1 mao"},
    {_id: 101002, name: "marcus2 mao"},
    {_id: 101003, name: "marcus3 mao"},
  ]
)

db.scores.insertMany(
  [
    {student_id: 101002, score: 90},
    {student_id: 101003, score: 80},
  ]
)

db.students.aggregate (
   [
    {
      $match: {_id: 101003}
    },
    {
      $lookup:
     {
       from: "scores",
       localField: "_id",
       foreignField: "student_id",
       as: "xx"
     }
    }
   ]
)

db.students.aggregate (
   [
    {
      $lookup:
     {
       from: "scores",
       localField: "_id",
       foreignField: "student_id",
       as: "xx"
     }
    }, {
      $match: {
        xx: {
          $not: {$size: 0}
        }
      }
    }
   ]
)

db.students.aggregate (
   [
    {
      $lookup:
     {
       from: "scores",
       localField: "_id",
       foreignField: "student_id",
       as: "xx"
     }
    }, {
      $match: {
        xx: {
          $not: {$size: 0}
        }
      }
    }, {
      $count: "row cnt"
    }
   ]
)

db.students.aggregate (
   [
    {
      $lookup:
     {
       from: "scores",
       localField: "_id",
       foreignField: "student_id",
       as: "xx"
     }
    }, {
      $match: {
        xx: {
          $not: {$size: 0}
        }
      }
    }, {
      $group: {
        _id: {x: "$_id"},
        count: { $count: { } }
      }
    }
   ]
)

db.students.aggregate (
   [
    {
      $lookup:
     {
       from: "scores",
       localField: "_id",
       foreignField: "student_id",
       as: "xx"
     }
    }, {
      $match: {
        xx: {
          $not: {$size: 0}
        }
      }
    }, {
      $group: {
        _id: null,
        count: { $count: { } }
      }
    }
   ]
)

db.students.aggregate (
   [
    {
      $lookup:
     {
       from: "scores",
       localField: "_id",
       foreignField: "student_id",
       as: "xx"
     }
    }, {
      $match: {
        xx: {
          $not: {$size: 0}
        }
      }
    }, {
      $unwind: "$xx"
    }, {
      $group: {
        _id: "$_id",
        count: { $sum: "$xx.score" }
      }
    }
   ]
)
```
