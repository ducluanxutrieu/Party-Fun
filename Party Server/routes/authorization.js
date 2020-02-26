var jwt = require('jsonwebtoken');
var config = require("../config");
var mongodb = require('mongodb');
var MongoClient = mongodb.MongoClient;
var emailExistence = require('email-existence');

function respon(res) {
    res.status(400).send({
        success: false, message: "The submitted values ​​are not in the correct format "
        , account: null
    });
}
function checkinvalid(requestval, type, length) {
    if ((requestval == undefined) || typeof (requestval) != type || requestval.length < length) {
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
                    return res.status(401).send();
                }
                else {
                    req.body.username = dec.username;
                    return next();
                }
            })
        }
        else res.status(401).send();
    },
    isStaff: function (req, res, next) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                var User = db.collection("User");
                User.find({ username: req.body.username }).toArray(function (err2, decoded) {
                    if (err2) throw err2;
                    else {
                        if (decoded[0].role == "nhanvien" || decoded[0].role == "Admin") {
                            return next();
                        }
                        else res.status(400).send({ success: false, message: "You need sign in with role nhanvien", dish: null });
                    }
                })
            })
    },

    checkinDataSignup: function (req, res, next) {
        if (checkinvalid(req.body.username, "string", 4)
        || (checkinvalid(req.body.password, "string", 6))
        || (checkinvalid(req.body.fullName, "string", 6))
        || (checkinvalid(req.body.email, "string", 10))) respon(res);
        else {
            req.body.phoneNumber = Number(req.body.phoneNumber);
            if ((isNaN(phone)) || phone.length < 9) respon(res);
            else
                // emailExistence.check(req.body.email, function (err, resp) {
                //     if (resp == false) res.status(401).send({ success: false, message: "Email not exist", account: null });
                //     else return next();
                // })
                return next();
        }
    },

    checkinDataChangePassword: function (req, res, next) {
        if (checkinvalid(req.body.password, "string", 6)
        || checkinvalid(req.body.newpassword, "string", 6)) respon(res);
        else return next();
    },

    checkinDataResetPassword: function (req, res, next) {
        if (checkinvalid(req.body.resetpassword, "string", 6)
        || checkinvalid(req.body.passwordnew, "string", 6)) respon(res);
        else return next();
    },

    checkinDataUpdateUser: function (req, res, next) {
        if (checkinvalid(req.body.fullName, 'string', 6)
        || checkinvalid(req.body.email, 'string', 10)) respon(res);
        else {
            req.body.phoneNumber = Number(req.body.phoneNumber);
            if (isNaN(phone) || phone.length < 9) respon(res);
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
                    if (isNaN(date) || isNaN(month) || isNaN(year) || date > 31 || date < 1 || month < 1 || month > 12 || year < 1 || year > yearnow.getFullYear() || (date >= yearnow.getDate() && month == (yearnow.getMonth() + 1) && year == yearnow.getFullYear()) || ((month > yearnow.getMonth() + 1) && year == yearnow.getFullYear())) respon(res);
                    else {
                        return next();
                    }
                }
            }
        }
    },

    checkinDateUpgraderole: function (req, res, next) {
        if (checkinvalid(req.body.userupgrade, "string", 4)) respon(res);
        else return next();
    },

    checkinDataDish: function (req, res, next) {
        req.body.price = Number(req.body.price);
        req.body.discount = Number(req.body.discount);
        if (checkinvalid(req.body.name, 'string', 1) || checkinvalid(req.body.description, 'string', 6) || checkinvalid(req.body.type, 'string', 2)) respon(res);
        else {
            if (isNaN(req.body.price) || isNaN(req.body.discount) || req.body.discount < 0 || req.body.discount >= 100 || req.body.price <= 0) respon(res);
            else {
                return next();
            }
        }
    },

    checkinDataBookDish: function (req, res, next) {
        if ((req.body.dateParty) == undefined) respon(res);
        else {
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
            else if ((date < yearnow.getDate() && month == (yearnow.getMonth() + 1) && year == yearnow.getFullYear()) || (month < yearnow.getMonth() + 1 && year == yearnow.getFullYear())) respon(res);
            else {
                req.body.numbertable = Number(req.body.numbertable);
                if (isNaN(req.body.numbertable)) respon(res);
                else if ((req.body.lishDishs) == undefined) respon(res);
                else {
                    try {
                        req.body.lishDishs = JSON.parse(req.body.lishDishs);
                    }
                    catch (e) {
                    }
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
