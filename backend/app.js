//DEPENDENCIES
let express = require('express');
let app = express();
let db = require(__dirname + '/db');
// const scheduler = require(__dirname + "/scheduler");
let bodyParser = require('body-parser');
const methodOverride = require('method-override');

let nodemailer = require('nodemailer');
const schedule = require("node-schedule");
const fs = require("fs");

//GLOBAL CONSTANTS
const PORT = process.env.PORT || 3000;
const CODE_COLLECTION_NAME = "mails";

const ERROR_JSON = {"success":false, "message":"Some error occured"};
const SUCCESS_JSON = {"success":true, "message":"Query was successful"};
const API_KEY_INVALID_JSON = {"success":false, "message":"Invalid API Key"};
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
    db.getDB().collection(CODE_COLLECTION_NAME).find({"email": emailId}).toArray((error,documents)=>{
        if(error){
            response.json(ERROR_JSON);
        } else {
            let toSendData = JSON.parse(JSON.stringify(SUCCESS_JSON)); //make a copy of success_json
            toSendData.results = documents;
            if (documents.length === 0) {
              let data = {
                email: emailId,
                sent_mails: [],
                future_mails: []
              }
              db.getDB().collection(CODE_COLLECTION_NAME).insertOne(data, (error,result)=>{
                  if(error){
                      console.log(error);
                  } else if(result.result.ok===1){
                      console.log("Added emailid");
                  } else {
                      console.log("Some error occured");
                  }
              });
            }
            response.json(toSendData);
        }
    });
});

//SEND MAIL
app.get('/scheduleMail', async (request,response)=>{

    //CHECK API KEY
    let apiKey = request.query.api_key;
    if(!checkApiKey(apiKey)) return response.json(API_KEY_INVALID_JSON);

    let transporter = nodemailer.createTransport({
      host: 'smtp.gmail.com',
      port: 465,
      secure: true,
      auth: {
        type: 'OAuth2',
        user: request.query.email_id,
        accessToken: request.query.tocken
      }
    });

    let mailOptions = {
      from: request.query.email_id,
      to: request.query.to.split(","),
      subject: request.query.subject,
      cc: request.query.cc.split(","),
      bcc: request.query.bcc.split(","),
      html: request.query.html
    };

    let data = {
      to: mailOptions.to,
      cc: mailOptions.cc,
      bcc: mailOptions.bcc,
      subject: mailOptions.subject,
      html_body: mailOptions.html,
      timestamp: Date.now(),
      attached_files: "-",
      schedule: request.query.schedule,
      method: request.query.method,
      seconds: request.query.seconds,
      minutes: request.query.minutes,
      hours: request.query.hours,
      day: request.query.day,
      date: request.query.date,
      month: request.query.month,
      year: request.query.year,
      id: request.query.id.toString()
    }
    let email = mailOptions.from;
    let time = {
      seconds: data.seconds,
      minutes: data.minutes,
      hours: data.hours,
      day: data.day,
      date: data.date,
      month: data.month,
      year: data.year
    }

    if (data.schedule === "true") {
      //DO THE JOB
      db.getDB().collection(CODE_COLLECTION_NAME).findOneAndUpdate({"email":email}, {$push:{"future_mails":data}}, async (error, result)=>{
        if(error){
            response.send(ERROR_JSON);
        } else if(result.ok===1){
            response.send(SUCCESS_JSON);
            // SCHEDULE MAILS
            let method = data.method;
            let id = data.id;
            // await addNewSchedule(id, email, method, time);
            await startMonitoring(id, email, method, time, transporter, mailOptions);
            // if (status) {
            //   response.send(SUCCESS_JSON);
            // } else {
            //   response.send(ERROR_JSON);
            // }
        } else {
            response.send(ERROR_JSON);
        }
      });
    } else {
      response.send(SUCCESS_JSON);
      await sendMailUsingNodemailer (transporter, mailOptions);
    }
});

// STOP SENDING MAIL
app.get('/stopMail', async (request,response)=>{

    //CHECK API KEY
    let apiKey = request.query.api_key;
    if(!checkApiKey(apiKey)) return response.json(API_KEY_INVALID_JSON);

    let id = request.query.id;
    let email = request.query.email_id;
    db.getDB().collection(CODE_COLLECTION_NAME).findOneAndUpdate({"email":email}, {$pull:{"future_mails":{"id": id}}}, (error, result)=>{
      if(error){
          console.log(error);
      } else if(result.ok===1){
          console.log("done");
      } else {
          console.log(result);
      }
    });
    await stopMonitoring(id);

    response.send(SUCCESS_JSON);
});

// FUNCTION TO SEND MAIL
function sendMailUsingNodemailer (transporter, mailOptions) {
  transporter.sendMail(mailOptions, function(error, info){
    if (error) {
      console.log(error);
    } else {
      console.log('Email sent: ' + info.response);
      let data = {
        to: mailOptions.to,
        cc: mailOptions.cc,
        bcc: mailOptions.bcc,
        subject: mailOptions.subject,
        html_body: mailOptions.html,
        timestamp: Date.now(),
        attached_files: "-",
        schedule: false
      }
      let email = mailOptions.from;

      //DO THE JOB
      db.getDB().collection(CODE_COLLECTION_NAME).findOneAndUpdate({"email":email}, {$push:{"sent_mails":data}}, (error, result)=>{
        if(error){
            console.log(error);
        } else if(result.ok===1){
            console.log("done");
        } else {
            console.log(result);
        }
      });
    }
  });
}

function addNewSchedule(id, email, method, time) {
    let jsonObject = {
      jobs: []
    };
    fs.readFile("database.json", "utf8", async (err, data) => {
      if (err) {
        console.log("error occurred while reading database file ", err);

        // initializing an object and pass stringified jsonObject into it
        let json = JSON.stringify(jsonObject);

        // if error is related to "file not found"
        if (err.code === "ENOENT") {
          console.log("file not found. Creating a new one ... ");

          // creates a new database.json file. This is for the first time only
          await fs.writeFile("database.json", json, "utf8", err => {
            if (err) console.log("Error in writing file ", err);
            else console.log("Successfully created a new file");

            // calling function reccursively, once new file is created, else block will be called
            addNewSchedule(id, email, method, time);
          });
        }
      } else {
        // parse the json file to manipulate data
        jsonOject = JSON.parse(data);

        // initialize a variable jobsArray and store  objects inside jobs array
        let jobsArray = jsonOject.jobs;

        // loop through the jobsArray to check duplicate and replace
        for (index in jobsArray) {
          if (jobsArray[index].id === id) {
            jobsArray.splice(index, 1);
          }
        }

        // push new object in array (database) got through parameters
        jsonOject.jobs.push({ id: id, email: email, method: method, time: time });

        //convert it back to json
        let json = JSON.stringify(jsonOject);

        // write it back
        fs.writeFile("database.json", json, "utf8", err => {
          if (err) console.log("Error in append ", err);
          else console.log("Successfully added in database");
        });
      }
    });
}

// Start Monitoring
function startMonitoring(id, email, method, time, transporter, mailOptions) {
  let setInterval;

  if (method === "Every 30 Seconds" || method === "Every 20 Seconds") {
    setInterval = '*/' + time.seconds + ' * * * * *';
  }

  else if (method === "Daily") {
    setInterval = time.minutes + ' ' + time.hours + ' * * *';
  }

  else if (method === "Weekly") {
    setInterval = time.minutes + ' ' + time.hours + ' * * ' + time.day;
  }

  else if (method === "Monthly") {
    setInterval = time.minutes + ' ' + time.hours + ' ' + time.date + ' * *';
  }

  else if (method === "Yearly") {
    setInterval = time.minutes + ' ' + time.hours + ' ' + time.date + ' ' + time.month + ' *';
  }

  /*
  starts schedule.
  1st parameter is the unique_id that identifies the job. I am using user email as a unique id
  2nd parameter is the interval set above
  in function body, you can write any thing that you want to perform as a cron job. I am calling
  a function that sends an email to user on every interval selected
*/
  console.log(id);
  console.log(typeof id);
  let i = 0;
  schedule.scheduleJob(id, setInterval, async () => {
    console.log("Start");
    var status = await sendMailUsingNodemailer(transporter, mailOptions);
    console.log("Running recur");
  });
}

// Stops a scheduled job when ever selected unsubscribed or interval is modified
function stopMonitoring (id) {
  // gets id of running job
  const schedule_id = id;

  // cancel the job
  const cancelJob = schedule.scheduledJobs[schedule_id];
  if (cancelJob == null) {
    return false;
  }
  cancelJob.cancel();
  return true;
}

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
