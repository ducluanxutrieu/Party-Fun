var express = require("express");
var bodyParser = require("body-parser");
var app = express();

app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

app.use((req,res,next) => {
    
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("Access-Control-Allow-Method", "PUT, DELETE, GET, POST");
    res.setHeader("Access-Control-Allow-Headers",
    "Access-Control-Allow-Headers,Origin,Accept,X-Requested-With,Content-Type,Access-Control-Request-Method,Access-Control-Request-Headers,authorization,rbr")
    next();
})

app.use('/', require('./routes/routes'));

var server=app.listen(3000, () => {
    console.log('Server running port '+server.address().port);
})