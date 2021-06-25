//DEPENDENCIES
let express = require('express');
let app = express();
let db = require(__dirname + '/db');
let bodyParser = require('body-parser');
const methodOverride = require('method-override');

//GLOBAL CONSTANTS
const PORT = process.env.PORT || 3000;
const FLIPR_COLLECTION_NAME = "mails";

const ERROR_JSON = {"success":false,"message":"Some error occured"};
const SUCCESS_JSON = {"success":true,"message":"Query was successful"};
const API_KEY_INVALID_JSON = {"success":false,"message":"Invalid API Key"};
const VALID_API_KEYS = ['GAURAV'];

//GLOBAL FUNCTIONS
const checkApiKey = (apiKey)=>{
    return VALID_API_KEYS.includes(apiKey);
}

//MIDDLEWARES
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(methodOverride('_method'));

//API ENDPOINTS

//HOME
app.get('/',(request,response)=>{
    //CHECK API KEY
    let apiKey = request.query.api_key;
    if(!checkApiKey(apiKey)) return response.send("Welcome to Code bois API! You need to have API Key to access this service.");
    return response.send("Welcome to our API! Enjoy the service.");
});

//GET MAILS
app.get('/getMails',(request,response)=>{

    //CHECK API KEY
    let apiKey = request.query.api_key;
    if(!checkApiKey(apiKey)) return response.json(API_KEY_INVALID_JSON);

    let emailId = request.query.email_id;

    //DO THE JOB
    db.getDB().collection(FLIPR_COLLECTION_NAME).find({"email": emailId}).toArray((error,documents)=>{
        if(error){
            response.json(ERROR_JSON);
        } else {
            let toSendData = JSON.parse(JSON.stringify(SUCCESS_JSON)); //make a copy of success_json
            toSendData.results = documents;
            response.json(toSendData);
        }
    });
});

//CONNECT TO MONGO DB
db.connect((error) => {
    console.log("Trying to connect to db...");
    if(error){
        console.log("Could not connect to db");
        console.log(error);
        process.exit(1);
    } else {
      app.listen(PORT, ()=>{
          console.log("Connected to db");
          console.log("Listening to "+ PORT);
      });
    }
});
