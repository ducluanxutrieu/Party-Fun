const mongodb = require('mongodb');
const jwt = require('jsonwebtoken');
const config = require('../../config');
const bcrypt = require('bcryptjs');
const fs = require('fs');
const ip = "139.180.131.30";
const port = "3000";
const nodemailer = require('nodemailer');
const MongoClient = mongodb.MongoClient;

module.exports = {
    signin: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                if (req.headers && req.headers.authorization) {
                    var tokenreq = req.headers.authorization;
                    jwt.verify(tokenreq, config.secret, function (err, dec) {
                        if (err) {
                            res.status(401).send({ success: false, message: 'Failed to authenticate token', account: null });
                        }
                        else {
                            collection.findOne({ username: dec.username }, (function (err2, decoded) {
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
                    if (req.body.username == undefined || req.body.password == undefined)
                        res.status(400).send({ success: false, message: "Username and password is not string", account: null })
                    else {
                        collection.find({ username: req.body.username }).toArray(function (err, resl) {
                            if (Array.isArray(resl) && resl.length == 0) res.status(400).send({ success: false, message: 'Signin failed, user not found', account: null });
                            else {
                                bcrypt.compare(req.body.password, resl[0].password, function (err, reslt) {
                                    if (reslt) {
                                        var token = jwt.sign({ username: req.body.username }, config.secret, {
                                            expiresIn: '2400h'
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

    signup: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                collection.find({ username: req.body.username }).toArray(function (err, docs) {
                    if (Array.isArray(docs) && docs.length === 0) {
                        var acc = req.body;
                        var hashedPassword = bcrypt.hashSync(acc.password, 8);
                        acc.password = hashedPassword;
                        acc.birthday = "";
                        acc.sex = "";
                        acc.role = "khachhang";
                        acc.imageurl = "http://" + ip + ":" + port + "/open_image?image_name=default.png";
                        acc.resetpassword = "";
                        var date = new Date();
                        acc.createAt = date.toLocaleString();
                        acc.updateAt = acc.createAt;
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

    signout: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                collection.findOne({ username: req.body.username }, (function (err2, decoded) {
                    if (err2 || !decoded)
                        return res.status(401).send({ success: false, message: 'Failed to authenticate token' });
                    else
                        res.status(200).send({ success: true, message: "Sign Out success" });
                }))
            })
    },

    changepassword: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                var requestpass = req.body.password;
                collection.find({ username: req.body.username }).toArray(function (err2, decoded) {
                    var user = decoded[0].username;
                    if (err2 || decoded.length == 0)
                        return res.status(401).send({ success: false, message: 'Failed to authenticate token' });

                    else {
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

    uploadavatar: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                collection.find({ username: req.body.username }).toArray(function (err2, decoded) {
                    if (err2 || decoded.length == 0)
                        return res.status(401).send({ success: false, message: 'Failed to authenticate token' });
                    else {
                        let formidable = require('formidable');
                        var form = new formidable.IncomingForm();
                        form.uploadDir = "./uploads";
                        form.keepExtensions = true;
                        form.maxFieldsSize = 10 * 1024 * 1024;
                        form.multiples = true;

                        form.parse(req, function (err2, fields, files) {
                            if (files["image"] == undefined || files["image"] == null ||
                                files["image"].type.match(/.(jpg|jpeg|png|form-data)$/i) == null)
                                res.status(400).send({ success: false, message: "No image to upload" });
                            else {
                                var url = "http://" + ip + ":" + port + "/open_image?image_name=" + files["image"].path.split('/')[1];
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

    resetpassword: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                collection.find({ username: req.body.username }).toArray(function (err, docs) {
                    if (Array.isArray(docs) && docs.length != 0) {
                        if (docs[0].email === undefined) res.status(400).send({ success: "false", message: "Your account has not updated its email address" });
                        var accmail = 'partyuitk11@gmail.com';
                        var passmail = 'partyuit123';
                        var smtptransport = nodemailer.createTransport({
                            service: 'Gmail',
                            host: 'smtp.gmail.com',
                            port: 587,
                            secure: false,
                            auth: {
                                user: accmail,
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
                            html: '<body> <tr> <td> <p style="font-weight:500; font-size:16px;"> Party Booking </p> </td> </tr> <p> Hello ' + req.body.username + '</p> <p> </p> <div> We have received a request change password your PartyBooking account. </div> Please input below code to application: <table border="0" cellspacing="0" cellpadding="0" style="border-collapse:collspse; margin-top:9px;margin-bottom:15px"><tbody> <tr> <td style="font-size:11px;font-famili:LucidaGrande,tahoma,verdana,arial,sans-serif;padding:10px;backgroup-color:#f2f2f2;border-left:1px solid #ccc; border-right:1px solid #cc"><span class="m_48" style="font-family:Helvetica Neue, Helvetica, Lucida Grande, tahoma, verdana, arial, sans-serif; font-size:16px;line-height:21px; color:#141823">' + resetpassword + '</span></td></tr></tbody></table><p></p> </body>'
                        };
                        smtptransport.sendMail(data, function (err) {
                            if (err) res.status(500).send({ success: false, message: err });
                            else res.status(200).send({ success: true, message: "Please check your email" + docs[0].email });
                        })
                    }
                    else res.status(400).send({ success: false, message: "Find not found username: " + req.body.username });
                })
            })
    },

    resetconfirm: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                collection.find({ resetpassword: req.body.resetpassword }).toArray(function (err, docs) {
                    if (docs.length != 0) {
                        var password = bcrypt.hashSync(req.body.passwordnew, 8);
                        collection.update({ resetpassword: req.body.resetpassword }, { $set: { password: password, resetpassword: "" } }, function (err2, resl) {
                            if (err2) res.status(500).send({ success: false, message: err2 });
                            else res.status(200).send({ success: true, message: "Update password success" });
                        })
                    }
                    else res.status(400).send({ success: false, message: "Code OTP incorrect" });
                })
            })
    },

    updateuser: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                collection.find({ username: req.body.username }).toArray(function (err2, decoded) {
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

    profile: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                console.log(req.connection.remoteAddress + " request Get profile username: " + req.body.username);
                var User = db.collection('User');
                User.aggregate([
                    {
                        $match: {
                            'username': req.body.username,
                        }
                    },
                    {
                        $lookup: {
                            from: 'Bill',
                            localField: 'username',
                            foreignField: 'username',
                            as: 'userCart'
                        }
                    },
                    { $project: { password: 0 } }
                ]).toArray(function (err, data) {
                    if (err) res.status(500).send({ success: false, message: err, account: null });
                    else res.status(200).send({ success: true, message: "Profile User", account: data[0] });
                })
            })
    },

    upgraderole: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                collection.find({ username: req.body.username }).toArray(function (err2, decoded) {
                    if (err2 || decoded.length == 0)
                        return res.status(500).send({ success: false, message: err2 });
                    else {
                        if (decoded[0].role == "Admin") {
                            collection.findOneAndUpdate({ username: req.body.userupgrade }, { $set: { role: "nhanvien" } }, { returnOriginal: false }, function (err, resl) {
                                if (err) res.status(500).send({ success: false, message: err });
                                else if (resl.value == null) res.status(400).send({ success: false, message: "Can't find user" });
                                else res.status(200).send({ success: true, message: "Upgrade Role success" });
                            });
                        }
                        else res.status(400).send({ success: false, message: "You need signin with Administrator" });
                    }
                })
            })
    },

    demotionrole: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                collection.find({ username: req.body.username }).toArray(function (err2, decoded) {
                    if (err2 || decoded.length == 0)
                        return res.status(500).send({ success: false, message: err2 });
                    else {
                        if (decoded[0].role == "Admin") {
                            collection.findOneAndUpdate({ username: req.body.userupgrade }, { $set: { role: "khachhang" } }, { returnOriginal: false }, function (err, resl) {
                                if (err) res.status(500).send({ success: false, message: err });
                                else if (resl.value == null) res.status(400).send({ success: false, message: "Can't find user" });
                                else res.status(200).send({ success: true, message: "Demotion Role success" });
                            });
                        }
                        else res.status(400).send({ success: false, message: "You need signin with Administrator" });
                    }
                })
            })
    },

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
    },
    findusernv: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab', function (err, db) {
                var User = db.collection('User');
                User.find({ role: 'nhanvien' }, { username: 1, fullName: 1, imageurl: 1 }).toArray(function (err, data) {
                    if (err) res.status(400).send({ success: false, message: "Error " + err, user: null });
                    else res.status(200).send({ success: true, message: 'Find all user success', user: data })
                })
            })
    },
    finduserkh: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost/Android_Lab', function (err, db) {
                var User = db.collection('User');
                User.find({ role: 'khachhang' }, { username: 1, fullName: 1, imageurl: 1 }).toArray(function (err, data) {
                    if (err) res.status(400).send({ success: false, message: 'Error' + err, user: null });
                    else res.status(200).send({ success: true, message: 'Find all user success', user: data })
                })
            })
    }
}