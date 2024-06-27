var app = require('express').Router();
var controller = require('./payment.controllers')

app.get('/get_payment', controller.get_payment);
module.exports=app;
