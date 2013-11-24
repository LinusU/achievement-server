
fs = require 'fs'
express = require 'express'
mongo = require 'mongodb'

db = new mongo.Db 'dev', new mongo.Server 'localhost', 27017

class User
  
  @find_by_id: (id, cb) ->
    @collection.find { id: id }, cb
  
  @find_or_create_by_id: (id, cb) ->
    @find_by_id id, (err, users) ->
      if users.items.length > 0
        cb err, users
      else
        @collection.insert

db.open ->
  db.collection 'users', (err, collection) ->
    User.collection = collection



app = express()

app.use express.bodyParser()

# app.use (req, res, next) ->
#   a = req.get 'X-Achievement-App'
#   b = req.get 'X-Achievement-Key'
#   if a and b
#     # FIXME: Check the key
#     file = a
#   else
#     file = 'dev'
#   res.set 'cfg', JSON.parse 

app.get '/', (req, res) ->
  res.send 'Hello world!'

app.get '/user/:user', (req, res) ->
  db.users.find id: req.params.user, (err, users) ->
    if users.items.length < 1
      res.send 404, "Not Found"
    else
      res.send JSON.stringify user: users.items[0]

app.post '/user/:user', (req, res) ->
  db.users.find id: req.params.user, (err, users) ->

    achievements =
      test: 1

    if users.items.length < 1
      db.users.save id: req.params.user, achievements: achievements
    else
      db.users.update { id: req.params.user }, achievements: achievements

    res.send 200, "OK"

app.listen 3000
