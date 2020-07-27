var express = require("express");
var bodyParser = require("body-parser");
var app = express();
var http=require('http');
var cors= require('cors');
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())
var morgan = require('morgan');
var fs = require('fs');
var path = require('path');
var accessLogStream = fs.createWriteStream(path.join(__dirname, 'access.log'), { flags: 'a' })

// setup the logger
app.use(morgan('combined', { stream: accessLogStream }))

app.use((req,res,next) => {
    res.setHeader('Accept-Encoding', 'gzip')
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Credentials", true);
    res.setHeader('Access-Control-Allow-Methods', "GET, PUT, POST, DELETE, OPTIONS");
    res.setHeader("Access-Control-Allow-Headers",
    "Access-Control-Allow-Headers,Origin,Accept,X-Requested-With,Content-Type,Access-Control-Request-Method,Access-Control-Request-Headers,authorization,rbr")
    next();
})
app.use(cors());
app.use('/', require('./routes/routes'));

var server=http.createServer(app);
server.listen(3000, () => {
    console.log('Server running Port ' + server.address().port);
})
