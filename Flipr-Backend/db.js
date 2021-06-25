const mongoose = require("mongoose");
const dbname = "Flipr";
const url =  "<MongoDB URL>";
const mongoOptions = {useNewUrlParser:true, useUnifiedTopology: true};

const state = {
    db:null
}

const connect = (cb) => {
    if(state.db){
        cb();
    } else {
        mongoose.connect(url, mongoOptions, (err,client) => {
            if(err){
                cb(err);
            } else {
              // console.log(client.connections[0].db);
                state.db = client.connections[0].db;
                cb();
            }
        });
    }
}

const getDB = () => {
    return state.db;
}

const getPrimaryKey = (_id)=>{
    return mongoose.Types.ObjectId(_id);
}

module.exports={getDB, connect, getPrimaryKey, mongoose, url};
