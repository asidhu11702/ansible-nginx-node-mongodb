var logger = require('winston');
var express = require('express');
var config = require('config');
var mongodb = require('mongodb');
var os = require('os');

var app = express();
var url = 'mongodb://' + 
    config.get('Env.database.host') + ':' + 
    config.get('Env.database.port') + '/' + 
    config.get('Env.database.name');

logger.log('info', "starting up...");

app.get('/', function(req, res){
    var mongo = mongodb.MongoClient;
    
    mongo.connect(url, function(err, db){
        if(err) 
            logger.log('error', 'Failed to connect to database at ', url);
        else
            logger.log('info', "successfully connected to database at ", url);

        db.close();
    });

    res.send(config.get('App.start_message') + 'from ' + os.hostname() + '\n');
});

const port = config.get("Env.node.listen_port");
app.listen(port);

logger.log('info', 'listening on port:', port);