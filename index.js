var http = require('http')
var request = require('request')

var endpoints = {"light_control": "http://localhost:8082" }

function routeCommand(command) {
  console.log(command);
  var endpoint = endpoints[command.category]
  request.post(endpoint, {body: JSON.stringify(command.commands)}, function (err, response, body) {
    if (err) {
      console.error("Unable to reach lights unit")
      return console.error(err);
    }
  })
}

function startCommandServer(port) {
  http.createServer(function (req, res) {
    var body = "";

    req.on('data', function (chunk) {
      body += chunk;
    });

    req.on('end', function () {
      res.end('OK!')
      var command = JSON.parse(body)
      routeCommand(command)
    })

  }).listen(port)
}

function start() {
  startCommandServer(8081)
}

start()
