module.exports = function (app) {

    var controller = require('./user.controllers')
    var auth=require('../authorization')
    //dang nhap user
    app.post('/user/signin', controller.signin);

    // dang ki
    app.post('/user/signup', auth.checkinDataSignup, controller.signup);

    //dang xuat
    app.post('/user/signout', auth.isAuthenticated, controller.signout);

    //doi mat khau
    app.post('/user/changepassword',auth.isAuthenticated, auth.checkinDataChangePassword, controller.changepassword);

    //upload avatar
    app.post('/user/uploadavatar',auth.isAuthenticated, controller.uploadavatar);

    //reset password
    app.post('/user/resetpassword', controller.resetpassword);

    //reset password confirm
    app.post('/user/resetconfirm', auth.checkinDataResetPassword, controller.resetconfirm);

    //update thong tin user
    app.post('/user/updateuser', auth.isAuthenticated, auth.checkinDataUpdateUser, controller.updateuser);

    // get thong tin user
    app.get('/user/profile', auth.isAuthenticated, controller.profile);

    // nang cap quyen
    app.post('/user/upgraderole', auth.isAuthenticated, auth.checkinDateUpgraderole, controller.upgraderole);

    // xoa quyen nhan vien
    app.delete('/user/demotionrole', auth.isAuthenticated, auth.checkinDateUpgraderole, controller.demotionrole);

    // xem anh
    app.get('/open_image', controller.open_image);

    // get danh sach username

    app.get('/user/findusernv', auth.isAuthenticated, auth.isStaff, controller.findusernv);

    app.get('/user/finduserkh', auth.isAuthenticated, auth.isStaff, controller.finduserkh);
}