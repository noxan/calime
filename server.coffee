express = require 'express'


app = express()

require('./config/express')(app)

require('./config/routes')(app)

app.listen app.get('port')
console.log "Server started on port " + app.get('port')
