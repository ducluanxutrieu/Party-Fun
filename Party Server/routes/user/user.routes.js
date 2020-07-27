
    var app=require('express').Router();
    var controller = require('./user.controllers')
    var auth=require('../authorization')
    var multer =require('multer');
    let diskStorage = multer.diskStorage({
        destination: (req, file, callback) => {
          // Định nghĩa nơi file upload sẽ được lưu lại
          callback(null, "uploads");
        },
        filename: (req, file, callback) => {
          // ở đây các bạn có thể làm bất kỳ điều gì với cái file nhé.
          // Mình ví dụ chỉ cho phép tải lên các loại ảnh png & jpg
          let math = ["image/png", "image/jpeg"];
          if (math.indexOf(file.mimetype) === -1) {
            let errorMess = `The file <strong>${file.originalname}</strong> is invalid. Only allowed to upload image jpeg or png.`;
            return callback(errorMess, null);
          }
          // Tên của file thì mình nối thêm một cái nhãn thời gian để đảm bảo không bị trùng.
          let filename = `${file.originalname}`;
          callback(null, filename);
        }
      });
      var upload = multer({ storage: diskStorage })
    //dang nhap user
    app.post('/signin', controller.signin);

    // dang nhap admin
    app.post('/sign_admin', controller.signin_admin);

    // dang ki
    app.post('/signup', auth.checkinDataSignup, controller.signup);

    //dang xuat
    app.get('/signout', controller.signout);

    //doi mat khau
    app.put('/change_pwd',auth.isAuthenticated, auth.checkinDataChangePassword, controller.changepassword);

    //upload avatar
    app.put('/avatar', upload.single('image'),auth.isAuthenticated, controller.uploadavatar);

    //reset password
    app.get('/reset_password', controller.resetpassword);

    //reset password confirm
    app.put('/confirm_otp', auth.checkinDataResetPassword, controller.resetconfirm);

    //update thong tin user
    app.put('/update', auth.isAuthenticated, auth.checkinDataUpdateUser, controller.updateuser);

    // get thong tin user
    app.get('/get_me', auth.isAuthenticated, controller.profile);

    app.get('/get_history_cart', auth.isAuthenticated, controller.get_history_cart);
    app.get('/get_history_cart/:id', auth.isAuthenticated, controller.get_detail_history_cart);

    // nang cap quyen
    app.put('/add_staff', auth.isAuthenticated, auth.checkinDateUpgraderole, controller.upgraderole);

    // xoa quyen nhan vien
    app.put('/del_staff', auth.isAuthenticated, auth.checkinDateUpgraderole, controller.demotionrole);

   // xuat all danh sach user
    app.get('/customers', auth.isAuthenticated, auth.isStaff, controller.finduserkh);
   // xuat all danh sach user nhanvien
    app.get('/staffs', auth.isAuthenticated, auth.isStaff, controller.findusernv);
    // search
    app.get('/search', auth.isAuthenticated, auth.isStaff, controller.search_customer);

module.exports=app;
