var {google} = require('googleapis')
var admin = require("firebase-admin");
// var http = require('http');
var serviceAccount = require("./service-account.json");
var MESSAGIN_SCOPE = "https://www.googleapis.com/auth/firebase.messaging"
var SCOPES = [MESSAGIN_SCOPE]

var express =  require("express");
var app = express();

var bodyParser = require('body-parser');
var router = express.Router();

var request = require('request');
const { title } = require('process');

app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

router.post('/send', function(req, res){

    getAccessToken().then(function(access_token){

        var title = req.body.title;
        var body = req.body.body;
        var token = req.body.token;

        request.post({
            headers: {
                Authorization: `Bearer ${access_token}`
            },
            url: 'https://fcm.googleapis.com/v1/projects/minichess-34a02/messages:send',
            body: JSON.stringify(
                {
                    "message":{
                       "token": token,
                       "notification":{
                         "body": body,
                         "title": title,
                       }
                    }
                 }
            )
        }, function(error, response, body){
            res.end(body);
            console.log(body);
        })
    });
})

var port = 8085

app.use('/api', router)

app.listen(port, function(){
    console.log(`server started on port ${port}`)
})

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://minichess-34a02-default-rtdb.firebaseio.com"
});


function getAccessToken() {
    return new Promise(function(resolve, reject) {
      const key = require('./service-account.json');
      const jwtClient = new google.auth.JWT(
        key.client_email,
        null,
        key.private_key,
        SCOPES,
        null
      );
      jwtClient.authorize(function(err, tokens) {
        if (err) {
          reject(err);
          return;
        }
        resolve(tokens.access_token);
      });
    });
  } 

//   var server = http.createServer(function(req, res){
//     getAccessToken().then(function(access_token){
//         res.end(access_token);
//       })

//   });

//   server.listen(3000, function(){
//     console.log('server started');
//   })