var app = require('express').Router();
var controller = require('./product.controllers')
var auth = require('../authorization')
//tao mon an
app.post('/adddish', auth.isAuthenticated, auth.isStaff, controller.adddish);

// cap nhat mon an
app.post('/updatedish', auth.isAuthenticated, auth.isStaff, auth.checkinDataDish, controller.update);

// upload anh, cong don vao danh sach anh hien tai
app.post('/uploadimage', auth.isAuthenticated, auth.isStaff, controller.uploadimage);

//delete mon an
app.delete('/deletedish', auth.isAuthenticated, auth.isStaff, controller.deletedish);

// in danh sach mon an
app.get('/finddish', controller.finddish);

//in thong tin mon an
app.post('/getItemDish', controller.getdish);

// dat ban
app.post('/book', auth.isAuthenticated, auth.checkinDataBookDish, controller.book);

// in ra id bill theo ten nguoi dung username
app.get('/findbill', auth.isAuthenticated, auth.isStaff, controller.findbill);

// in danh sach bill
app.get('/findallbill', auth.isAuthenticated, auth.isStaff, controller.findallbill);

// xoa bill
app.delete('/deletebill', auth.isAuthenticated, auth.isStaff, controller.deletebill);

// thanh toan
app.post('/pay', auth.isAuthenticated, auth.isStaff, controller.pay);

// thong ke
app.get('/statisticalmoney', auth.isAuthenticated, auth.isStaff, controller.statisticalmoney);

app.get('/statisticaldish', auth.isAuthenticated, auth.isStaff, controller.statisticaldish);

// danh gia mon an
app.post('/ratedish', auth.isAuthenticated, controller.rate);

module.exports = app;