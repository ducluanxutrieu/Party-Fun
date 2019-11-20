var mongodb = require('mongodb');
var bodyParser = require('body-parser');// dung khai bao de doc res.body
var jwt = require('jsonwebtoken');
var config = require('../../config');
var bcrypt = require('bcryptjs');
var fs = require('fs');
var crypto = require('crypto');
var ip = "localhost";
var port = "3000";

var nodemailer = require('nodemailer');
var MongoClient = mongodb.MongoClient;

module.exports = {
    // dang nhap 
    signin: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                if (err) console.log("Unable to connect")
                var collection = db.collection("User");
                //kiem tra dang nhap bang token 

                if (req.headers && req.headers.authorization) {
                    var tokenreq = req.headers.authorization;      // doc gia tri token
                    if (!tokenreq) return res.status(400).send({ success: false, message: 'No token provided', account: null });
                    console.log(req.connection.remoteAddress + " request Sign In. Content:" + JSON.stringify(req.headers.authorization));
                    jwt.verify(tokenreq, config.secret, function (err, dec) {
                        if (err) {
                            res.status(401).send({ success: false, message: 'Failed to authenticate token', account: null });
                        }
                        else {
                            // sau khi giai ma token ta duoc obj ten username. tim username trong database de response
                            collection.findOne({ username: dec.username }, (function (err2, decoded) {  // gia ma token thanh decoded la obj
                                if (err2 || !decoded)
                                    return res.status(401).send({ success: false, message: 'Failed to authenticate token', account: null });

                                else {
                                    delete decoded.password;
                                    var response =
                                    {
                                        success: true,
                                        message: "Sign in success",
                                        account: decoded
                                    }
                                    res.status(200).send(response);
                                }
                            }))
                        }
                    });
                }
                else {
                    // login with user and password
                    console.log(req.connection.remoteAddress + " request Sign In. Content:" + JSON.stringify(req.body));
                    if (req.body.username == undefined || req.body.password == undefined || typeof (req.body.username) != "string" || typeof (req.body.password) != "string")
                        res.status(400).send({ success: false, message: "Username and password is not string", account: null })
                    else {
                        collection.find({ username: req.body.username }).toArray(function (err, resl) {
                            if (Array.isArray(resl) && resl.length == 0) res.status(400).send({ success: false, message: 'Signin failed, user not found', account: null });
                            else {
                                bcrypt.compare(req.body.password, resl[0].password, function (err, reslt) {
                                    if (reslt) {
                                        // create token
                                        var token = jwt.sign({ username: req.body.username }, config.secret, {
                                            expiresIn: '2400h'  // thời gian sử dụng token
                                        });
                                        delete resl[0].password;
                                        resl[0].token = token;
                                        var response =
                                        {
                                            success: true,
                                            message: "Sign in success",
                                            account: resl[0]
                                        }
                                        res.status(200).send(response);
                                    }
                                    else res.status(400).send({ success: false, message: "Wrong Password", account: null });
                                });
                            }
                        });
                    }
                }
            });
    },

    // dang ki
    signup: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                if (err) console.log("Unable to connect")
                var collection = db.collection("User");
                console.log(req.connection.remoteAddress + " request Sign Up. Content:" + JSON.stringify(req.body));
                collection.find({ username: req.body.username }).toArray(function (err, docs) {
                    if (Array.isArray(docs) && docs.length === 0)     // tim k thay
                    {
                        var acc = req.body;
                        // ma hoa password
                        var hashedPassword = bcrypt.hashSync(acc.password, 8);
                        acc.password = hashedPassword;
                        // insert
                        acc.birthday = "";
                        acc.sex = "";
                        acc.role = "khachhang";
                        acc.imageurl = "http://" + ip + ":" + port + "/open_image?image_name=default.png";
                        acc.resetpassword = "";
                        var date = new Date();
                        acc.createAt = date.toLocaleString();
                        acc.updateAt = acc.createAt;
                        acc.userCart = [];
                        collection.insert(acc, (function (err, reslute) {
                            if (err) {
                                res.status(500).send({ success: false, message: err, account: null });
                            }
                            else {
                                delete acc.password;
                                var response =
                                {
                                    success: true,
                                    message: "Sign Up success",
                                    account: acc
                                };
                                res.status(200).send(response);
                            }
                        }));
                    }
                    else {
                        // add tai khoan da ton tai, err, send 400
                        var response =
                        {
                            success: false,
                            message: "Account already exists",
                            account: req.body
                        };
                        res.status(400).send(response);
                    }
                })
            })
    },

    // dang xuat
    signout: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                if (err) console.log("Unable to connect")
                var collection = db.collection("User");
                console.log(req.connection.remoteAddress + " request Sign Out. Content:" + JSON.stringify(req.body));
                // sau khi giai ma token ta duoc obj ten username. tim username trong database de response
                collection.findOne({ username: req.body.username }, (function (err2, decoded) {  // gia ma token thanh decoded la obj
                    if (err2 || !decoded)
                        return res.status(401).send({ success: false, message: 'Failed to authenticate token' });
                    else
                        res.status(200).send({ success: true, message: "Sign Out success" });
                }))
            })
    },

    // doi mat khau
    changepassword: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                if (err) console.log("Unable to connect")
                var collection = db.collection("User");
                var requestpass = req.body.password;
                console.log(req.connection.remoteAddress + " request Change Password. Content:" + JSON.stringify(req.body));
                // sau khi giai ma token ta duoc obj ten username. tim username trong database de response
                collection.find({ username: req.body.username }).toArray(function (err2, decoded) {
                    // gia ma token thanh decoded la obj
                    var user = decoded[0].username;
                    if (err2 || decoded.length == 0)
                        return res.status(401).send({ success: false, message: 'Failed to authenticate token' });

                    else {
                        // so sánh mật khẩu gửi lên và mật khẩu đã mã hóa lưu trong database
                        bcrypt.compare(requestpass, decoded[0].password, function (err2, reslt) {
                            if (reslt) {
                                var requestpassnew = bcrypt.hashSync(req.body.newpassword, 8);
                                collection.update({ username: user },
                                    { $set: { password: requestpassnew } }, function (err2, reslt) {
                                        if (err2) res.send({ success: false, message: err2 });
                                        res.status(200).send({ success: true, message: "Password updated" });
                                    })
                            }
                            else res.status(400).send({ success: false, message: "Wrong Password" });
                        })
                    }
                })
            })
    },

    // cap nhat anh avatar
    uploadavatar: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                if (err) console.log("Unable to connect")
                var collection = db.collection("User");
                console.log(req.connection.remoteAddress + " request Upload Avatar User");
                collection.find({ username: req.body.username }).toArray(function (err2, decoded) {  // gia ma token thanh decoded la obj
                    if (err2 || decoded.length == 0)
                        return res.status(401).send({ success: false, message: 'Failed to authenticate token' });
                    else {
                        let formidable = require('formidable');
                        var form = new formidable.IncomingForm();
                        form.uploadDir = "./uploads";   // thu muc luu
                        form.keepExtensions = true;     // duoi file
                        form.maxFieldsSize = 10 * 1024 * 1024;  // kich thuoc
                        form.multiples = true; //cho phep gui nhieu file

                        form.parse(req, function (err2, fields, files) {
                            if (files["image"] == undefined || files["image"] == null ||
                                files["image"].type.match(/.(jpg|jpeg|png)$/i) == null) // đuôi file chấp nhận
                                res.status(400).send({ success: false, message: "No image to upload" });
                            else {
                                var url = "http://" + ip + ":" + port + "/open_image?image_name=" + files["image"].path.split('\\')[1];

                                collection.update({ username: decoded[0].username }, { $set: { imageurl: url } }, function (err3, reslt) {
                                    if (err3) res.status(500).send({ success: false, message: err3 });
                                    else {
                                        res.status(200).send({ success: true, message: url });
                                    }
                                });
                            }
                        });
                    }
                })
            })
    },

    //reset password
    resetpassword: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                if (err) console.log("Unable to connect")
                var collection = db.collection("User");
                console.log(req.connection.remoteAddress + " request Send Reset Password. Content:" + JSON.stringify(req.body));
                collection.find({ username: req.body.username }).toArray(function (err, docs) {
                    if (Array.isArray(docs) && docs.length != 0)  // tim thay
                    {
                        if (docs[0].email === undefined) res.status(400).send({ success: "false", message: "Your account has not updated its email address" });
                        var accmail = 'partyuitk11@gmail.com';
                        var passmail = 'partyuit123';
                        var smtptransport = nodemailer.createTransport({
                            service: 'Gmail',
                            auth: {
                                user: accmail, // user password email de dang nhap va gui 
                                pass: passmail
                            }
                        })
                        var resetpassword = (Math.floor(Math.random() * 888888 + 111111)).toString(); // random 1 so tu 111111 den 999999
                        collection.update({ username: docs[0].username }, { $set: { resetpassword: resetpassword } }, function (err, re) {
                            if (err) res.status(500).send({ success: "false", message: err });
                        })
                        var data = {
                            from: accmail,
                            to: docs[0].email,
                            subject: "Reset Password PartyBooking",
                            text: "Ban vua yeu cau reset password cho tai khoan " + req.body.username + ". Su dung ma: " + resetpassword
                        };
                        // send mail mã reset password
                        smtptransport.sendMail(data, function (err) {
                            if (err) res.status(500).send({ success: false, message: err });
                            res.status(200).send({ success: true, message: "Please check your email" + docs[0].email });
                        })
                    }
                    else res.status(400).send({ success: false, message: "Find not found username: " + req.body.username });
                })
            })
    },

    // nhap ma reset password
    resetconfirm: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                if (err) console.log("Unable to connect")
                var collection = db.collection("User");
                collection.find({ resetpassword: req.body.resetpassword }).toArray(function (err, docs) {
                    if (docs.length != 0) {
                        // băm mật khẩu mới để lưu vào
                        var password = bcrypt.hashSync(req.body.passwordnew, 8);
                        collection.update({ resetpassword: req.body.resetpassword }, { $set: { password: password, resetpassword: "" } }, function (err2, resl) {
                            if (err2) res.status(500).send({ success: false, message: err2 });
                            res.status(200).send({ success: true, message: "Update password success" });
                        })
                    }
                    else res.status(400).send({ success: false, message: "Code OTP incorrect" });
                })
            })
    },

    // cap nhat thong tin user
    // các trường được cập nhật: fullName, sex, birthday, phoneNumber, email, updateAt
    updateuser: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                if (err) console.log("Unable to connect")
                var collection = db.collection("User");
                console.log(req.connection.remoteAddress + " request Update User. Content:" + JSON.stringify(req.body));
                collection.find({ username: req.body.username }).toArray(function (err2, decoded) {  // gia ma token thanh decoded la obj
                    if (err2 || decoded.length == 0)
                        return res.status(401).send({ success: false, message: 'Failed to authenticate token', account: null });
                    else {
                        var date = new Date();
                        var updateat = date.toLocaleString();
                        collection.update({ username: decoded[0].username }, {
                            $set: {
                                fullName: req.body.fullName, sex: req.body.sex,
                                birthday: req.body.birthday, phoneNumber: req.body.phoneNumber, email: req.body.email, updateAt: updateat
                            }
                        }, function (err2, resl) {
                            if (err2) res.status(500).send({ success: false, message: err2, account: null });
                            collection.find({ username: decoded[0].username }).toArray(function (err, doc) {
                                delete doc[0].password;
                                res.status(200).send({ success: true, message: "Update success", account: doc[0] });
                            })
                        });
                    }
                });
            })
    },

    // get thong tin user của chính mình
    profile: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                if (err) console.log("Unable to connect")
                var collection = db.collection("User");
                console.log(req.connection.remoteAddress + " request Get profile user. Content:" + JSON.stringify(req.body));
                collection.find({ username: req.body.username }).toArray(function (err, docs) {
                    if (err || docs.length == 0) res.status(400).send({ success: false, message: "User not found", account: null });
                    delete docs[0].password;
                    res.status(200).send({ success: true, message: "Profile User", account: docs[0] });
                })
            })
    },

    // nang cap quyen cho nhan vien
    // userupgrade: user được nâng quyền
    upgraderole: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                if (err) console.log("Unable to connect")
                var collection = db.collection("User");
                console.log(req.connection.remoteAddress + " request Upgrade Role. Content:" + JSON.stringify(req.body));
                collection.find({ username: req.body.username }).toArray(function (err2, decoded) {  // gia ma token thanh decoded la obj
                    if (err2 || decoded.length == 0)
                        return res.status(500).send({ success: false, message: err2 });
                    else {
                        if (decoded[0].role == "Admin") {
                            collection.update({ username: req.body.userupgrade }, { $set: { role: "nhanvien" } }, function (err, resl) {
                                if (err) res.status(500).send({ success: false, message: err });
                                res.status(200).send({ success: true, message: "Upgrade Role success" });
                            });
                        }
                        else res.status(400).send({ success: false, message: "You need signin with Administrator" });
                    }
                })
            })
    },
    // xóa quyền nhân viên cho user
    // userupgrade: user nhân viên bị giáng quyền từ nhân viên xuống khác hàng
    demotionrole: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                if (err) console.log("Unable to connect")
                var collection = db.collection("User");
                console.log(req.connection.remoteAddress + " request Upgrade Role. Content:" + JSON.stringify(req.body));
                collection.find({ username: req.body.username }).toArray(function (err2, decoded) {  // gia ma token thanh decoded la obj
                    if (err2 || decoded.length == 0)
                        return res.status(500).send({ success: false, message: err2 });
                    else {
                        if (decoded[0].role == "Admin") {
                            collection.update({ username: req.body.userupgrade }, { $set: { role: "khachhang" } }, function (err, resl) {
                                if (err) res.status(500).send({ success: false, message: err });
                                res.status(200).send({ success: true, message: "Demotion Role success" });
                            });
                        }
                        else res.status(400).send({ success: false, message: "You need signin with Administrator" });
                    }
                })
            })
    },
    // xem anh
    open_image: function (req, res) {
        let imagename = "./uploads/" + req.query.image_name;
        try {
            var image = fs.readFileSync(imagename);
        }
        catch (e) {
            res.writeHead(400, { "Content-Type": "text/html" })
            return res.end("File not found");

        }
        res.writeHead(200, { "Content-Type": "image/jpeg" });
        return res.end(image);
    }

}

