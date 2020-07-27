var app = require('express').Router();
var controller = require('./product.controllers')
var auth = require('../authorization')
var multer = require('multer');
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
var upload = multer({ storage: diskStorage });

//tao mon an
app.post('/dish', auth.isAuthenticated, auth.isStaff, controller.add_dish);
// cap nhat mon an
app.put('/dish', auth.isAuthenticated, auth.isStaff, auth.checkinDataDish, controller.update_dish);
//delete mon an
app.delete('/dish', auth.isAuthenticated, auth.isStaff, controller.del_dish);
//hủy đơn
app.put('/bill/:id', auth.isAuthenticated, auth.isStaff, controller.del_bill);
// xác nhận đơn
app.post('/bill/:id', auth.isAuthenticated, auth.isStaff, controller.confirm_bill);
// in danh sach mon an
app.get('/dishs', controller.get_list_dish);
// get danh sach mon an theo chuyen muc
app.get('/get_dish_by_categories', controller.get_list_dish_by_categories);
// in thong tin mon an
app.get('/dish/:id', controller.get_dish);
// đánh giá
app.post('/rate', auth.isAuthenticated, controller.add_rate);
// chỉnh sửa đánh giá
app.put('/rate', auth.isAuthenticated, controller.edit_rate);
// xóa đánh giá
app.delete('/rate', auth.isAuthenticated, controller.del_rate);
app.get('/rate', controller.get_rate);
// dat ban
app.post('/book', auth.isAuthenticated, auth.checkinDataBookDish, controller.book);
// in ra id bill theo ten nguoi dung username
app.get('/bill/:name', auth.isAuthenticated, auth.isStaff, controller.find_bill_by_id);
// in danh sach bill giam dan theo ngay. 
app.get('/bill', auth.isAuthenticated, auth.isStaff, controller.list_bill);
// thanh toan
app.post('/payment/:id', auth.isAuthenticated, auth.isStaff, controller.payment);
// thong ke tien
app.get('/statistic_money', auth.isAuthenticated, auth.isStaff, controller.statistic_money);
// thong ke mon an
app.get('/statistic_dish', auth.isAuthenticated, auth.isStaff, controller.statistic_dish);
// thong ke khach hang
app.get('/statistic_customer', auth.isAuthenticated, auth.isStaff, controller.statistic_customer);
// thong ke nhan vien
app.get('/statistic_staff', auth.isAuthenticated, auth.isStaff, controller.statistic_staff);
// thong ke dashboard
app.get('/get_dashboard', auth.isAuthenticated, auth.isStaff, controller.statistic_dashboard);
// upload hinh
app.post('/upload_image', upload.array('image', 10), auth.isAuthenticated, controller.upload_image);
// thêm cateogries
app.post('/categories', auth.isAuthenticated, auth.isStaff, controller.add_categories);
// lấy danh sách categories
app.get('/categories', controller.get_categories);
// chỉnh sửa
app.put('/categories', auth.isAuthenticated, auth.isStaff, controller.edit_categories);
// xóa
app.delete('/categories', auth.isAuthenticated, auth.isStaff, controller.del_categories);
// add post
app.post('/posts', auth.isAuthenticated, auth.isStaff, controller.add_post);
app.put('/posts', auth.isAuthenticated, auth.isStaff, controller.edit_post);
app.get('/posts/:id', controller.get_post);
app.get('/posts', controller.get_list_post);
app.delete('/posts/:id', auth.isAuthenticated, auth.isStaff, controller.delete_post);
// mã giảm giá
// list mã giảm giá
app.get('/discounts', auth.isAuthenticated, auth.isStaff, controller.get_list_discount_code);
// list mã giảm giá còn ngày hết hạn
app.get('/discount_expiresIn', auth.isAuthenticated, controller.get_discount_code_of_user);
app.post('/discount', auth.isAuthenticated, auth.isStaff, auth.isAdmin, controller.add_discount_code);

app.get('/cpu', auth.isAuthenticated, auth.isStaff, controller.get_status_cpu);

module.exports = app;
