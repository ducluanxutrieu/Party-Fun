var app = require('express').Router();
var controller = require('./user.controllers')
var auth = require('../authorization')
//dang nhap user
app.post('/signin', controller.signin);

// dang ki
app.post('/signup', auth.checkinDataSignup, controller.signup);

//dang xuat
app.post('/signout', auth.isAuthenticated, controller.signout);

//doi mat khau
app.post('/changepassword', auth.isAuthenticated, auth.checkinDataChangePassword, controller.changepassword);

//upload avatar
app.post('/uploadavatar', auth.isAuthenticated, controller.uploadavatar);

//reset password
app.post('/resetpassword', controller.resetpassword);

//reset password confirm
app.post('/resetconfirm', auth.checkinDataResetPassword, controller.resetconfirm);

//update thong tin user
app.post('/updateuser', auth.isAuthenticated, auth.checkinDataUpdateUser, controller.updateuser);

// get thong tin user
app.get('/profile', auth.isAuthenticated, controller.profile);

// nang cap quyen
app.post('/upgraderole', auth.isAuthenticated, auth.checkinDateUpgraderole, controller.upgraderole);

// xoa quyen nhan vien
app.delete('/demotionrole', auth.isAuthenticated, auth.checkinDateUpgraderole, controller.demotionrole);

// get danh sach username nhan vien
app.get('/findusernv', auth.isAuthenticated, auth.isStaff, controller.findusernv);

// get danh sach username khach hang
app.get('/finduserkh', auth.isAuthenticated, auth.isStaff, controller.finduserkh);

module.exports = app;