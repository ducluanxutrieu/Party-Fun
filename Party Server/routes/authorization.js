var jwt = require('jsonwebtoken');
var config = require("../config");
var mongodb = require('mongodb');
var MongoClient = mongodb.MongoClient;

function respon(res) {
    res.status(400).send({
        success: false, message: "The submitted values ​​are not in the correct format"
        , account: null
    });
}
function check(requestval, type, length) {
    if ((requestval == undefined) || typeof (requestval) != type || requestval.length < length) {
        return true;
    }
    else return false;
}
module.exports = {
    // xác thực token, xác nhận là user
    isAuthenticated: function (req, res, next) {
        if (req.headers && req.headers.authorization) {
            var tokenreq = req.headers.authorization;      // doc gia tri token
            if (!tokenreq) return res.status(400).json({ success: false, message: 'No token provided', account: null });
            jwt.verify(tokenreq, config.secret, function (err, dec) {
                if (err) {
                    return res.status(401).json({ success: false, message: 'Failed to authenticate token', account: null });
                }
                else {
                    req.body.username = dec.username;
                    return next();
                }
            })
        }
        else res.status(401).json({ success: false, message: 'Failed to authenticate token', account: null });
    },
    // xác thực quyền là nhân viên hoặc Admin
    isStaff: function (req, res, next) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                if (err) console.log("Unable to connect")
                var User = db.collection("User");
                User.find({ username: req.body.username }).toArray(function (err2, decoded) {  // gia ma token thanh decoded la obj
                    if (err2 || decoded.length == 0)
                        return res.status(401).send({ success: false, message: 'Failed to authenticate token', dish: null });
                    else {
                        if (decoded[0].role == "nhanvien" || decoded[0].role == "Admin") {
                            return next();
                        }
                        else res.status(400).send({ success: false, message: "You need sign in with role nhanvien", dish: null });
                    }
                })
            })
    },
    // kiểm tra dữ liệu khi đăng ký tài khoản. Dữ liệu đầu vào gồm
    //username: kiểu string, tối thiểu 4 kí tự
    //password: kiểu string, tối thiểu 6 kí tự
    //fullName: kiểu string, tối thiểu 6 kí tự
    // email: kiểu string, tối thiểu 10 kí tự
    // phoneNumber: kiểu number, tối thiểu 9 kí tự
    checkinDataSignup: function (req, res, next) {
        var request = new Object();

        // kiem tra gia tri
        if (check(req.body.username, "string", 4)) respon(res);
        else if (check(req.body.password, "string", 6)) respon(res);
        else if (check(req.body.fullName, "string", 6)) respon(res);
        else if (check(req.body.email, "string", 10)) respon(res);
        else {
            var phone = Number(req.body.phoneNumber);
            if ((isNaN(phone)) || typeof (phone) != "number" || phone.length < 9) respon(res);
            else {
                // gan gia tri
                request.username = req.body.username;
                request.password = req.body.password;
                request.fullName = req.body.fullName;
                request.email = req.body.email;
                request.phoneNumber = req.body.phoneNumber;
                req.body = request;
                return next();
            }
        }
    },
    //kiểm tra dữ liệu khi thay đổi mật khẩu user
    // password: mật khẩu hiện tại
    // newpassword: mật khẩu mới
    checkinDataChangePassword: function (req, res, next) {
        if (check(req.body.password, "string", 6)) respon(res);
        else if (check(req.body.newpassword, "string", 6)) respon(res);
        else return next();
    },
    // kiểm tra dữ liệu khi đặt lại mật khẩu
    // resetpassword: mã reset mật khẩu được gửi về email gồm 6 chữ số
    // passwordnew: mật khẩu mới
    checkinDataResetPassword: function (req, res, next) {
        if (check(req.body.resetpassword, "string", 6)) respon(res);
        else if (check(req.body.passwordnew, "string", 6)) respon(res);
        else return next();
    },
    // cập nhật thông tin user
    // cập nhật các trường fullName, email, phoneNumber, birthday( định dạng MM/DD/YYYY), sex(Male/Female)
    // phoneNumber để kiểu string để giữ số 0 trước sđt. Khi chuyển về number sẽ không có số 0 đầu 
    checkinDataUpdateUser: function (req, res, next) {
        if (check(req.body.fullName, "string", 6)) respon(res);
        else if (check(req.body.email, "string", 10)) respon(res);
        else {
            var phone = Number(req.body.phoneNumber);
            if ((isNaN(phone)) || typeof (phone) != "number" || phone.length < 9) respon(res);
            else if (req.body.sex == undefined || (req.body.sex != "Male" && req.body.sex != "Female")) respon(res);
            else {

                if ((req.body.birthday) == undefined) respon(res);
                else {
                    try {
                        var date = Number(req.body.birthday.split('/')[1]);
                        var month = Number(req.body.birthday.split('/')[0]);
                        var year = Number(req.body.birthday.split('/')[2]);
                    }
                    catch (e) {
                        respon(res);
                    }
                    var yearnow = new Date();
                    // kiểm tra ngày tháng hợp lệ, nhỏ hơn ngày hiện tại
                    if (isNaN(date) || isNaN(month) || isNaN(year) || date > 31 || date < 1 || month < 1 || month > 12 || year < 1 || year > yearnow.getFullYear() || (date >= yearnow.getDate() && month == (yearnow.getMonth() + 1) && year == yearnow.getFullYear()) || month > yearnow.getMonth() + 1) respon(res);
                    else return next();
                }
            }
        }
    },
    // nâng cấp quyền user từ khách hàng lên nhân viên.
    // userupgrade: user được nâng cấp, phải đăng nhập bằng user role Admin
    checkinDateUpgraderole: function (req, res, next) {
        if (check(req.body.userupgrade, "string", 4)) respon(res);
        else return next();
    },
    // check in data cap nhatmon an
    // name: tên món ăn
    // description: mô tả về món ăn
    // type: loại món ăn(món chính/ tráng miệng/ nước/ khai vị,....)
    //price: giá tiền >0
    // discount: khuyến mãi. 0 <= discount < 100
    checkinDataDish: function (req, res, next) {
        req.body.price = Number(req.body.price);
        req.body.discount=Number(req.body.discount);
        if (check(req.body.name, "string", 1)) respon(res);
        else if (check(req.body.description, "string", 6)) respon(res);
        else if (check(req.body.type, "string", 2)) respon(res);
        else {
            if (isNaN(req.body.price)|| isNaN(req.body.discount) || req.body.discount <0 || req.body.discount>=100 || req.body.price<=0) respon(res);
            else {
                var temp = new Object();
                temp.name = req.body.name;
                temp.description = req.body.description;
                temp.price = Number(req.body.price);
                temp.type = req.body.type;
                temp.discount=Number(req.body.discount);
                temp._id=req.body._id;
                req.body = temp;
                return next();
            }
        }
    },
    // check dat ban
    // dateParty: ngày đặt tiệc, định dạng MM/DD/YYYY H:M
    // numbertable: số bàn đặc tiệc
    // lishDishs: danh sách món ăn đặt, gồm 1 mảng, các đối tượng là 1 biến thuộc kiểu JSON bao gồm trường _id là _id món ăn, numberDish là số lượng món ăn ứng với _id đó
    checkinDataBookDish: function (req, res, next) {
        if ((req.body.dateParty) == undefined) respon(res);
        else {
            // kiểm tra ngày đặt tiệc thời gian hợp lệ, lớn hơn hoặc bằng ngày hiện tại
            try {
                var date = Number(req.body.dateParty.split(' ')[0].split('/')[1]);
                var month = Number(req.body.dateParty.split(' ')[0].split('/')[0]);
                var year = Number(req.body.dateParty.split(' ')[0].split('/')[2]);
                var hours = Number(req.body.dateParty.split(' ')[1].split(':')[0]);
                var min = Number(req.body.dateParty.split(' ')[1].split(':')[1]);
                req.body.dateParty = new Date(req.body.dateParty).toLocaleString();
            }
            catch (e) {
                respon(res);
            }
            var yearnow = new Date();
            if (isNaN(date) || isNaN(month) || isNaN(year) || date > 31 || date < 1 || month < 1 || month > 12 || year < 1 || year < yearnow.getFullYear()
                || isNaN(hours) || isNaN(min) || hours < 0 || hours > 24 || min < 0 || min > 60)
                respon(res);
            else if ((date < yearnow.getDate() && month == (yearnow.getMonth() + 1) && year == yearnow.getFullYear()) || month < yearnow.getMonth() + 1) respon(res);
            else {
                if (check(req.body.numbertable, "string", 0)) respon(res)
                else {
                    req.body.numbertable = Number(req.body.numbertable);
                    if (isNaN(req.body.numbertable)) respon(res);
                    else if (check(req.body.lishDishs, "string", 20)) respon(res);
                    else {
                        req.body.lishDishs = JSON.parse(req.body.lishDishs);
                        for (var i = 0; i < req.body.lishDishs.length; i++) {
                            req.body.lishDishs[i].numberDish = Number(req.body.lishDishs[i].numberDish);
                            if (isNaN(req.body.lishDishs[i].numberDish))
                                respon(res);
                            else {
                                var ObjectId = require('mongodb').ObjectID;
                                if (req.body.lishDishs[i]._id == undefined || ObjectId.isValid(req.body.lishDishs[i]._id) == false) res.status(400).send({ success: false, message: "_ID" + req.body.lishDishs[i]._id + " illegal" });
                                else if (i == req.body.lishDishs.length - 1) return next();
                            }
                        }
                    }
                }
            }
        }

    }

}
