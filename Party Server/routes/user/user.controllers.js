const mongodb = require('mongodb');
const jwt = require('jsonwebtoken');
const config = require('../../config');
const bcrypt = require('bcryptjs');
const fs = require('fs');
const ip = "139.180.131.30";
const port = "3000";
const nodemailer = require('nodemailer');
const MongoClient = mongodb.MongoClient;
var path=require('path');
var CronJob = require('cron').CronJob;
var ObjectId =  require('mongodb').ObjectId;

// cron check user là khách hàng bạc / vàng / đồng theo thời gian tham gia vào nhóm
let cron= new CronJob({
    cronTime: '0 0 0 */1 * *',
    // cronTime: '0 * * * * *',
    onTick: async function () {
        MongoClient.connect(
            'mongodb://localhost:27017/Android_Lab',
            function (err, db) {
                var User = db.collection("User");
                User.find({}).toArray(function(err, data) {
                    let now = new Date();
                    for (let index of data) {
                        let check_update = 0;
                        if ((now.getTime() - index.create_at.getTime() < 30 * 86400*1000) && (now.getTime() - index.create_at.getTime() >= 86400 *1000))
                        {
                            // neu nguoi dung do đăng kí được 1 ngày đến 1 tháng thì sẽ thuộc loại đồng / người mới
                            if (index.type.indexOf("new")==-1) 
                            {
                                // chua co thi insert vao mang
                                check_update = 1;
                                index.type.push("new");
                            }
                        }
                        else
                        if ((now.getTime() - index.create_at.getTime() >= 30 * 86400*1000) && (now.getTime() - index.create_at.getTime() < 30 * 86400 *1000 * 30 * 6))
                        {
                            // neu nguoi dung do đăng kí được 1 tháng đến 6 tháng thì sẽ thuộc loại bạc / thân thuộc
                            if (index.type.indexOf("familiar")==-1) 
                            {
                                // neu co thi update mang
                                if (index.type.indexOf("new")!=-1) index.type[index.type.indexOf("new")]="familiar";
                                else 
                                index.type.push("familiar");
                                check_update = 1;
                            }
                        }
                        else
                        if (now.getTime() - index.create_at.getTime() >= 30 * 86400 * 1000 * 30 * 60)
                        {
                            // neu nguoi dung do đăng kí được hơn 6 tháng thì sẽ thuộc loại vàng    // lâu năm
                            if (index.type.indexOf("vip")==-1) 
                            {
                                // neu co thi update mang
                                if (index.type.indexOf("familiar")!=-1) index.type[index.type.indexOf("familiar")]="vip";
                                else 
                                index.type.push("vip");
                                check_update = 1;
                            }
                        }
                        if (check_update == 1) User.update({_id: new ObjectId(index._id)}, {$set: {type: index.type}}, function(err, data) {
                        });
                    }
                })
            })
    },
    timeZone: "Asia/Ho_Chi_Minh",
    start: true,
})
module.exports = {
    signin: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost:27017/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                if (req.headers && req.headers.authorization) {
                    var tokenreq = req.headers.authorization;
                    jwt.verify(tokenreq, config.secret, function (err, dec) {
                        if (err || !dec) {
                            res.status(401).send({message: "Mã token không chính xác hoặc đã hết hạn", data: "false"});
                        }
                        else {
                            collection.findOne({ username: dec.username }, function (err2, decoded) {
                                if (err2 || !decoded)
                                    return res.status(401).send({message: "Mã token không chính xác hoặc đã hết hạn", data: "false" });
                                else {
                                    delete decoded.password;
                                    decoded.token= null;
                                    res.status(200).send({message: "Đăng nhập token thành công", data: decoded});
                                }
                            })
                        }
                    });
                }
                else {
                    if (!(req.body.username && req.body.password))
                        res.status(400).send({ message: "Trường username và password không được trống", data: "false" })
                    else {
                        collection.findOne({ username: req.body.username },function (err, data) {
                            if (err || !data) res.status(400).send({message: 'Không tìm thấy username trong hệ thống', data: "false" });
                            else {
                                bcrypt.compare(req.body.password, data.password, function (err, crypt) {
                                    if (crypt) {
                                        var token = jwt.sign({ username: req.body.username }, config.secret, {
                                            expiresIn: '2400h'
                                        });
                                        delete data.password;
                                        data.token = token;
                                        res.status(200).send({message: "Đăng nhập thành công", data: data });
                                    }
                                    else res.status(400).send({message: "Mật khẩu không chính xác", data: "false" });
                                });
                            }
                        });
                    }
                }
            });
    },
    signin_admin: function(req, res) {
        MongoClient.connect(
            'mongodb://localhost:27017/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                if (req.headers && req.headers.authorization) {
                    var tokenreq = req.headers.authorization;
                    jwt.verify(tokenreq, config.secret, function (err, dec) {
                        if (err || !dec) {
                            res.status(401).send({message: "Mã token không chính xác hoặc đã hết hạn", data: "false"});
                        }
                        else {
                            collection.findOne({ username: dec.username }, function (err2, decoded) {
                                if (err2 || !decoded)
                                    return res.status(401).send({message: "Mã token không chính xác hoặc đã hết hạn", data: "false" });
                                else 
                                if (decoded.role == 2 || decoded == 3) 
                                {
                                    delete decoded.password;
                                    decoded.token= null;
                                    res.status(200).send({message: "Đăng nhập token thành công", data: decoded});
                                }
                                else res.status(400).send({message: "Bạn không có quyền sử dụng tính năng này", data: "false"})
                            })
                        }
                    });
                }
                else {
                    if (!(req.body.username && req.body.password))
                        res.status(400).send({ message: "Trường username và password không được trống", data: "false" })
                    else {
                        collection.findOne({ username: req.body.username },function (err, data) {
                            if (err || !data) res.status(400).send({message: 'Không tìm thấy username trong hệ thống', data: "false" });
                            else {
                                bcrypt.compare(req.body.password, data.password, function (err, crypt) {
                                    if (crypt) 
                                    {
                                        if (data.role == 2 || data.role == 3)
                                            {
                                            var token = jwt.sign({ username: req.body.username }, config.secret, {
                                                expiresIn: '2400h'
                                            });
                                            delete data.password;
                                            data.token = token;
                                            res.status(200).send({message: "Đăng nhập thành công", data: data });
                                        }
                                        else res.status(400).send({message: "Bạn không có quyền sử dụng tính năng này", data: "false"})
                                    }
                                    else res.status(400).send({message: "Mật khẩu không chính xác", data: "false" });
                                });
                            }
                        });
                    }
                }
            });
    },
    signup: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost:27017/Android_Lab',
            function (err, db) {
                if (err) console.log(err);
                var collection = db.collection("User");
                collection.findOne({ username: req.body.username },function (err, data) {
                    if (!(data)) {
                        var acc = req.body;
                        var hashedPassword = bcrypt.hashSync(acc.password, 8);
                        acc.password = hashedPassword;
                        acc.birthday = new Date();
                        acc.gender = 1;
                        acc.role = 1;
                        acc.type = [];
                        acc.avatar = "http://" + ip + ":" + port + "/open_image?image_name=default.png";
                        acc.otp_register = null;
                        acc.otp_register_at = null;
                        acc.create_at = new Date();
                        acc.update_at = new Date();
                        if (!acc.country_code) acc.country_code = "+84"
                        collection.insert(acc, (function (err, reslute) {
                            if (err) {
                                res.status(500).send({message: "Lỗi khi insert database", data: "false"});
                            }
                            else {
                                delete acc.password;
                                var response =
                                {
                                    message: "Đăng kí thành công",
                                    data: acc
                                };
                                res.status(200).send(response);
                            }
                        }));
                    }
                    else {
                        res.status(400).send({message: "Tài khoản đã tồn tại", data: "false"});
                    }
                })
            })
    },

    signout: function (req, res) {
        res.status(200).send({message: "Đăng xuất thành công", data: "true" });
    },

    changepassword: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost:27017/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                collection.findOne({ username: req.body.username }, function (err2, decoded) {
                    if (err2)
                        return res.status(400).send({ message: 'User không tồn tại', data: "false" });
                    else {
                        bcrypt.compare(req.body.password, decoded.password, function (err2, reslt) {
                            if (reslt) {
                                let requestpassnew = bcrypt.hashSync(req.body.new_password, 8);
                                collection.update({ username: decoded.username },
                                    { $set: { password: requestpassnew } }, function (err2, data) {
                                        if (err2) res.send({ message: "Lỗi khi cập nhật mật khẩu mới", data: null });
                                        else res.status(200).send({ message: "Cập nhật mật khẩu thành công", data: "true" });
                                    })
                            }
                            else res.status(400).send({ message: "Mật khẩu không chính xác", data: "false" });
                        })
                    }
                })
            })
    },

    uploadavatar: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost:27017/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                collection.findOne({ username: req.body.username },function (err2, decoded) {
                    if (err2 || !decoded)
                        return res.status(401).send({ message: 'Tài khoản không tồn tại', data: "false" });
                    else {
                        if (req.file && req.file.filename) 
                        {
                            var url = "http://" + ip + ":" + port + "/open_image?image_name=" + req.file.filename;
                            collection.update({ username: decoded.username }, { $set: { avatar: url } }, function (err3, reslt) {
                                if (err3) res.status(500).send({message: "Lỗi khi cập nhật ảnh đại diện", data: "false"});
                                else {
                                    res.status(200).send({ message: "Cập nhật ảnh đại diện thành công", data: url });
                                }
                            });
                        }
                        else res.status(400).send({message: "Không tồn tài ảnh đại diện đính kèm. Vui lòng chọn 1 hình ảnh làm ảnh đại diện", data: "false"});
                    }
                })
            })
    },

    resetpassword: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost:27017/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                collection.findOne({ username: req.query.username },function (err, data) {
                    if (data && data.length != 0) {
                        if (data.email.length==0) res.status(400).send({message: "Tài khoản bạn chưa cập nhật địa chỉ email", data: "false" });
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
                        var resetpassword = (Math.floor(Math.random() * 888888 + 111111)); // random 1 so tu 111111 den 999999
                        collection.update({ username:data.username }, { $set: { otp_register: resetpassword, otp_register_at: new Date() } }, function (err, re) {
                            if (err) res.status(500).send({message: "Lỗi khi cập nhật mã OTP code", data: err });
                        })
                        var data_send = {
                            from: accmail,
                            to: data.email,
                            subject: "Reset Password PartyBooking",
                            html: '<body> <tr> <td> <p style="font-weight:500; font-size:16px;"> Party Booking </p> </td> </tr> <p> Hello ' + req.query.username + '</p> <p> </p> <div> We have received a request change password your PartyBooking account. </div> Please input below code to application: <table border="0" cellspacing="0" cellpadding="0" style="border-collapse:collspse; margin-top:9px;margin-bottom:15px"><tbody> <tr> <td style="font-size:11px;font-famili:LucidaGrande,tahoma,verdana,arial,sans-serif;padding:10px;backgroup-color:#f2f2f2;border-left:1px solid #ccc; border-right:1px solid #cc"><span class="m_48" style="font-family:Helvetica Neue, Helvetica, Lucida Grande, tahoma, verdana, arial, sans-serif; font-size:16px;line-height:21px; color:#141823">' + resetpassword + '</span></td></tr></tbody></table><p></p> </body>'
                        };
                        smtptransport.sendMail(data_send, function (err) {
                            if (err) res.status(500).send({ message: "Lỗi khi gửi email", data: "false" });
                            else res.status(200).send({message: "Yêu cầu reset mật khẩu thành công. Làm ơn kiểm tra email " + data.email, data: data.email });
                        })
                    }
                    else res.status(400).send({message: "Tài khoản không tồn tại", data: "false" });
                })
            })
    },

    resetconfirm: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost:27017/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                collection.findOne({ otp_register: Number(req.body.otp_code), username: req.body.username },function (err, data) {
                    if (data && (new Date().getTime() < (data.otp_register_at.getTime()+60*60*1000))) {
                        var password = bcrypt.hashSync(req.body.password, 8);
                        collection.update({ username: req.body.username }, { $set: { password: password, otp_register: null } }, function (err2, resl) {
                            if (err2) res.status(500).send({ message: "Lỗi khi cập nhật password mới", data: "false" });
                            else res.status(200).send({ message: "Cập nhật mật khẩu thành công", data: "true" });
                        })
                    }
                    else res.status(400).send({ message: "Code OTP không chính xác hoặc đã hết hạn" });
                })
            })
    },

    updateuser: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost:27017/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                collection.findOne({ username: req.body.username} ,function (err2, data) {
                    if (err2 || !data)
                        return res.status(401).send({message: 'Tài khoản không tồn tại', data: "false" });
                    else {
                        var updateat =new Date();
                        collection.update({ username: data.username }, {
                            $set: {
                                full_name: req.body.full_name, gender: Number(req.body.gender),
                                birthday: req.body.birthday, phone: Number(req.body.phone), 
                                email: req.body.email, update_at: updateat
                            }
                        }, function (err2, resl) {
                            if (err2) res.status(500).send({ message: "Lỗi khi update user", data: "false" });
                            else collection.findOne({ username: data.username },function (err, doc) {
                                delete doc.password;
                                res.status(200).send({message: "Cập nhật thông tin user thành công", data: doc });
                            })
                        });
                    }
                });
            })
    },

    profile: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost:27017/Android_Lab',
            function (err, db) {
                var User = db.collection('User');
                User.findOne({username: req.body.username}, function(err, data) {
                    if (data) {
                        delete data.password;
                        res.status(200).send({ message: "Lấy thông tin user", data: data })
                    }
                    else res.status(400).send({message: "Tài khoản không tồn tại", data: "false"})
                })
            })
    },
    get_history_cart: function(req, res) {
        MongoClient.connect(
            'mongodb://localhost:27017/Android_Lab',
            async function (err, db) {
                var Bill = db.collection('Bill');
                if (!req.query.page || req.query.page < 1) req.query.page = 1;
                let total_page = (await Bill.find({customer: req.body.username}).toArray()).length;
                total_page = Math.ceil(total_page / 10);
                Bill.find({customer: req.body.username}).sort({date_party: -1}).limit(10).skip(10*Number(req.query.page -1))
                .toArray(function (err, data) {
                    if (err) res.status(500).send({ message: "Bill rỗng", data: "false" });
                    else {
                        res.status(200).send({ message: "Lấy lịch sử đặt hàng thành công", data: {
                            total_page: total_page,
                            start: 10 * (req.query.page -1),
                            end: (10 * (req.query.page) -1),
                            value: data,
                         } });
                    }
                })
            })
    },
    get_detail_history_cart: function(req, res) {
        MongoClient.connect(
            'mongodb://localhost:27017/Android_Lab',
            async function (err, db) {
                var Bill = db.collection('Bill');
                var ObjectID = require('mongodb').ObjectID;

                Bill.findOne({_id: new ObjectID(req.params.id)},
                function (err, data) {
                    if (err) res.status(500).send({ message: "Bill rỗng", data: "false" });
                    else {
                        res.status(200).send({ message: "Lấy chi tiết lịch sử đặt hàng thành công", data});
                    }
                })
            })
    },

    upgraderole: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost:27017/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                collection.findOne({ username: req.body.username },function (err2, decoded) {
                    if (err2 || !decoded)
                        return res.status(500).send({message: "Tài khoản đăng nhập không tồn tại", data: "false" });
                    else {
                        if (decoded.role == 3) {
                            var ObjectID = require('mongodb').ObjectID;
                            collection.findOneAndUpdate({ _id: new ObjectID(req.body.user_id), role: 1 }, { $set: { role: 2 } }, { returnOriginal: false }, function (err, resl) {
                                if (err || resl.value == null) res.status(400).send({  message: "User cần thêm không chính xác", data: "false" });
                                else res.status(200).send({ message: "Cập nhật quyền thành công", data: "true" });
                            });
                        }
                        else res.status(400).send({ message: "Bạn không có quyền thực hiện tính năng này", data: "false" });
                    }
                })
            })
    },

    demotionrole: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost:27017/Android_Lab',
            function (err, db) {
                var collection = db.collection("User");
                collection.findOne({ username: req.body.username },function (err2, decoded) {
                    if (err2 || !decoded)
                        return res.status(500).send({message: "Tài khoản đăng nhập không tồn tại", data: "false" });
                    else {
                        if (decoded.role == 3) {
                            var ObjectID = require('mongodb').ObjectID;
                            collection.findOneAndUpdate({ _id: new ObjectID(req.body.user_id), role: 2 }, { $set: { role: 1 } }, { returnOriginal: false }, function (err, resl) {
                                if (err || resl.value == null) res.status(400).send({  message: "User cần xóa không chính xác", data: "false" });
                                else res.status(200).send({ message: "Cập nhật quyền thành công", data: "true" });
                            });
                        }
                        else res.status(400).send({ message: "Bạn không có quyền thực hiện tính năng này", data: "false" });
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
            'mongodb://localhost:27017/Android_Lab', async function (err, db) {
                var User = db.collection('User');
                if (!req.query.page || req.query.page < 1) req.query.page = 1;
                let total_page = (await User.find({role: 2}).toArray()).length;
                total_page = Math.ceil(total_page / 10);
                User.find({ role: 2 }, { username: 1, full_name: 1, avatar: 1 }).limit(10).skip(10*Number(req.query.page -1 )).toArray(function (err, data) {
                    if (err) res.status(400).send({message: "Lỗi khi tìm nhân viên",data: "false" });
                    else res.status(200).send({ message: 'In tất cả nhân viên', data: {
                        total_page: total_page,
                        start: 10 * (req.query.page -1),
                        end: (10 * (req.query.page) -1),
                        value: data,
                    } })
                })
            })
    },
    finduserkh: function (req, res) {
        MongoClient.connect(
            'mongodb://localhost:27017/Android_Lab', async function (err, db) {
                var User = db.collection('User');
                if (!req.query.page || req.query.page < 1) req.query.page = 1;
                let total_page = (await User.find({role: 1}).toArray()).length;
                total_page = Math.ceil(total_page / 10);
                User.find({ role: 1 }, { username: 1, full_name: 1, avatar: 1 }).limit(10).skip(10*Number(req.query.page - 1)).toArray(function (err, data) {
                    if (err) res.status(400).send({message: "Lỗi khi tìm danh sách khách hàng", data: "false" });
                    else res.status(200).send({message: "In tất cả khách hàng", data: {
                        total_page: total_page,
                        start: 10 * (req.query.page -1),
                        end: (10 * (req.query.page) -1),
                        value: data,
                    } })
                })
            })
    },
    search_customer: function(req, res) {
        MongoClient.connect(
            'mongodb://localhost:27017/Android_Lab', function (err, db) {
                var User = db.collection('User');
                User.find({username: {'$regex': req.query.key}}).toArray(function (err, data) {
                    if (err) res.status(400).send({message: "Lỗi khi search", data: "false" });
                    else 
                    {
                        if (data && data.length!=0) {
                            for (let index of data) {
                                delete index.password;
                            }
                        }
                        res.status(200).send({message: "Tìm kiếm user theo username", data: data });
                    }
                })
            })
    }
}
