var jwt = require('jsonwebtoken');
var config = require("../config");
var mongodb = require('mongodb');
var MongoClient = mongodb.MongoClient;
// var emailExistence = require('email-existence');

function respon(res, msg) {
    res.status(400).send({
       message: msg, data: "false"
    });
}
function check(requestval, length) {
    if (!(requestval) || requestval.length < length) {
        return true;
    }
    else return false;
}
module.exports = {
    isAuthenticated: function (req, res, next) {
        if (req.headers && req.headers.authorization) {
            var tokenreq = req.headers.authorization;
            jwt.verify(tokenreq, config.secret, function (err, dec) {
                if (err) {
                    console.log(err);
                    return res.status(401).send({message: "Mã token không chính xác hoặc đã hết hạn", data: "false"});
                }
                else 
                if (dec && dec.username) {
                    MongoClient.connect(
                        'mongodb://localhost:27017/Android_Lab',
                        async function (err, db) {
                            var User = db.collection("User");
                            let check_exist = await User.findOne({username: dec.username});
                            if (check_exist)
                            {
                                req.body.username = dec.username;
                                return next();
                            }
                            else respon(res, "Mã token không chính xác");
                        })
                   
                }
            })
        }
        else res.status(401).send({message:"Bạn cần đăng nhập để thực hiện chức năng này", data: "false" });
    },
    isStaff: function (req, res, next) {
        MongoClient.connect(
            'mongodb://localhost:27017/Android_Lab',
            function (err, db) {
                var User = db.collection("User");
                User.findOne({ username: req.body.username },function (err2, decoded) {
                    if (decoded && (decoded.role == 2 || decoded.role == 3)) {
                        return next();
                    }
                    else res.status(400).send({ message: "Bạn không có quyền thực hiện chức năng này", data: "false" });
                })
            })
    },
    isAdmin: function (req, res, next) {
        MongoClient.connect(
            'mongodb://localhost:27017/Android_Lab',
            function (err, db) {
                var User = db.collection("User");
                User.findOne({ username: req.body.username },function (err2, decoded) {
                    if (decoded && decoded.role == 3) {
                        return next();
                    }
                    else res.status(400).send({ message: "Bạn phải là Admin để sử dụng tính năng này", data: "false" });
                })
            })
    },

    checkinDataSignup: function (req, res, next) {
        if (check(req.body.username, 4)) respon(res, "Trường username không được rỗng, phải lớn hơn 4 kí tự");
        else if (check(req.body.password, 6)) respon(res, "Trường pass word không được rỗng, phải lớn hơn 6 kí tự");
        else if (check(req.body.full_name, 6)) respon(res, "Trường full name không được rỗng, phải lớn hơn 6 kí tự");
        else if (check(req.body.email, 10)) respon(res, "Trường email không được rỗng, phải lớn hơn 10 kí tự");
        else {
            req.body.phone = Number(req.body.phone);
            if (req.body.phone && req.body.phone.toString().length < 9) respon(res, "Trường phone không chính xác");
            else {
                return next();
            }
        }
    },

    checkinDataChangePassword: function (req, res, next) {
        if (check(req.body.password,  6)) respon(res, "Trường password không được rỗng, phải lớn hơn 6 kí tự");
        else if (check(req.body.new_password,  6)) respon(res, "Trường password mới không được rỗng, phải lớn hơn 6 kí tự");
        else return next();
    },

    checkinDataResetPassword: function (req, res, next) {
        if (check(req.body.otp_code,  6)) respon(res, "Trường OTP code reset password không được rỗng");
        else if (check(req.body.password,  6)) respon(res, "Mật khẩu mới không được rỗng");
        else if (check(req.body.username,  4)) respon(res, "Trường username không được rỗng");
        else return next();
    },

    checkinDataUpdateUser: function (req, res, next) {
        if (check(req.body.full_name,  6)) respon(res, "Trường full name không được rỗng, tối thiểu 6 kí tự");
        else if (check(req.body.email, 10)) respon(res , "Trường email không được rỗng, tối thiểu 10 kí tự");
        else {
            req.body.phone = Number(req.body.phone);
            req.body.gender = Number(req.body.gender);
            if (isNaN(req.body.gender) || (req.body.gender!=1 && req.body.gender!=2)) req.body.gender = 1;
            if (req.body.phone && req.body.phone.toString().length< 8 ) respon(res, "Trường phone không được rỗng");
            else {
                if (!(req.body.birthday)) respon(res, "Trường ngày sinh không được rỗng");
                else {
                    let date=new Date(req.body.birthday);
                    let now = new Date();
                    if (date.getTime() > now.getTime()) respon(res, "Trường ngày sinh không được lớn hơn ngày hiện tại");
                    else {
                        return next();
                    }
                }
            }
        }
    },

    checkinDateUpgraderole: function (req, res, next) {
        if (check(req.body.user_id, 4)) respon(res, "Trường user_id cần thêm không được rỗng");
        else return next();
    },

    checkinDataDish: function (req, res, next) {
        if (req.body.price)
        req.body.price = Number(req.body.price);
        if (req.body.discount)
        req.body.discount = Number(req.body.discount);
        return next();
    },

    checkinDataBookDish: function (req, res, next) {
        if (!(req.body.date_party) || req.body.date_party.length==0) respon(res, "Trường ngày tổ chức tiệc không được trống");
        else {
            req.body.date_party=new Date(req.body.date_party);
            var now = new Date();
            if (req.body.date_party.getTime() < now.getTime() || isNaN(req.body.date_party.getTime())) respon(res, "Trường ngày tổ chức tiệc không thể nhỏ hơn ngày hiện tại")
            else {
                req.body.table = Number(req.body.table);
                if (req.body.count_customer && !isNaN(Number(req.body.count_customer))) req.body.count_customer = Number(req.body.count_customer);
                else req.body.count_customer = 0;
                if (!req.body.table || isNaN(req.body.table) || req.body.table == 0) respon(res, "Trường số bàn không được trống, là số nguyên");
                else if (!(req.body.dishes)) respon(res, "Trường danh sách món ăn không được rỗng");
                else  {
                    try {
                        req.body.dishes = JSON.parse(req.body.dishes);
                    }
                    catch (e) {
                    }
                    for (let index of req.body.dishes) {
                    if (index.count)
                        index.count = Number(index.count);
                }
                return next();
                }
            }
        }
    }
}
