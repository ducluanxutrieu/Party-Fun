var mongodb = require('mongodb');
var MongoClient = mongodb.MongoClient;
const stripe = require('stripe')('sk_test_sppgoJtCA1UMEVOdYu1oPNAV00k44l2JeS');
const nodemailer = require('nodemailer');

module.exports = {
    get_payment: function (req, res) {
        if (req.query._id) {
            MongoClient.connect(
                'mongodb://localhost:27017/Android_Lab',
                function (err, db) {
                    let Bill = db.collection("Bill");
                    let User = db.collection("User");
                    var ObjectId = require('mongodb').ObjectID;
                    User.findOne({ username: req.body.username }, function (err, data) {
                        if (err || !data) res.status(400).send({ message: "Username không tồn tại", data: "false" });
                        else {
                            let email = data.email;
                            Bill.findOne({ _id: new ObjectId(req.query._id), payment_status: 0 }, async function (err, bill) {
                                if (err || !bill) res.status(400).send({ message: "Không tìm thấy id hóa đơn", data: "false" });
                                else {
                                    let line_items = [];
                                    for (let dish of bill.dishes) {
                                        line_items.push({
                                            name: dish.name,
                                            images: (dish.feature_image)?[dish.feature_image]: ["http://172.16.13.94:3000/open_image?image_name=default.png"],
                                            amount: dish.total_money,
                                            currency: dish.currency,
                                            quantity: dish.count * bill.table,
                                        });
                                    }
                                    if (line_items.length != 0) {
                                        let session = await stripe.checkout.sessions.create({
                                            payment_method_types: ['card'],
                                            success_url: `http://172.16.13.94/client/payment/success`,
                                            cancel_url: `http://172.16.13.94/client/payment/cancel`,
                                            customer_email: email,
                                            line_items: line_items,
                                            client_reference_id: req.query._id
                                        });
                                        if (session) res.status(200).send({ message: "Tạo session thanh toán thành công", data: session })
                                        else res.status(400).send({ message: "Lỗi khi tạo session", data: "false" });
                                    }
                                    else res.status(400).send({ message: "List món ăn trong bill rỗng", data: "false" });
                                }
                            })
                        }
                    })
                })
        }
        else res.status(400).send({message: "ID bill không được rỗng", data: "false"});
    },
    payment_success: function (req, res) {
        if (req.body.type == 'checkout.session.completed') {
            let session = req.body.data.object;
            MongoClient.connect(
                'mongodb://localhost:27017/Android_Lab',
                function (err, db) {
                    let Bill = db.collection("Bill");
                    var ObjectId = require('mongodb').ObjectID;
                    Bill.findOneAndUpdate({ _id: new ObjectId(session.client_reference_id) }, { $set: { payment_at: new Date(), payment_status: 1, payment_type: 1 } }, { returnOriginal: false }, function (err, resl) {
                        if (err) console.log(err);
                        else if (resl.value) {
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
                            var data = {
                                from: accmail,
                                to: session.customer_email,
                                subject: "Thanh toán thành công",
                                text: "Kính chào quý khách. Quý khách hàng vừa thanh toán thành công hóa đơn " + session.client_reference_id + " tại ứng dụng PartyBooking. Tổng tiền hóa đơn là: " + resl.value.total + " VND, thanh toán lúc " + new Date(resl.value.payment_at).toLocaleString() + " Trân trọng cám ơn quý khách hàng đã ủng hộ"
                            };
                            smtptransport.sendMail(data, function (err) {
                                if (err) console.log(err);
                            });
                            // update type 
                            var User = db.collection("User");
                            Bill.aggregate([
                                {
                                    $match: {
                                        "customer": resl.value.customer,
                                        "payment_status": 1
                                    }
                                },
                                { 
                                    $group: {
                                        _id: "$customer",
                                        total: {$sum: "$total"}
                                    }
                                }
                            ]).toArray(async function(err, result){ 
                                if (result && result.length!=0) {
                                    var user = await User.findOne({username: resl.value.customer});
                                    console.log(user);
                                    let check_update = 0;
                                    // neu tong tien người dùng đó đã thanh toán trên 5 triệu -> 20triệu thì sẽ là khách hàng có tiềm năng lớn
                                    if (result[0].total > 5000000 && result[0].total <20000000)
                                    {
                                        if (user.type.indexOf("potential")==-1) 
                                        {
                                            // neu co thi update mang
                                            if (user.type.indexOf("wandering")!=-1) user.type[index.type.indexOf("wandering")]="potential";
                                            else 
                                            user.type.push("potential");
                                            check_update = 1;
                                        }
                                    }
                                    // khách hàng trung thành Loyal 
                                    else if (result[0].total > 20000000) {
                                        if (user.type.indexOf("loyal")==-1) 
                                        {
                                            // neu co thi update mang
                                            if (user.type.indexOf("potential")!=-1) user.type[user.type.indexOf("potential")]="loyal";
                                            else 
                                            user.type.push("loyal");
                                            check_update = 1;
                                        }
                                    }
                                    else if (result[0].total > 1000000 && result[0].total < 5000000) // khách hàng mang lại giá trị nhỏ
                                    {
                                        if (user.type.indexOf("wandering")!=-1) 
                                        {
                                            user.type.push('wandering');
                                            check_update = 1;
                                        }
                                    }
                                    if (check_update == 1) {
                                        User.update({username: resl.value.customer}, {$set: {type: user.type}});
                                    }
                                }
                            })
                        }
                    })
                })
            res.status(200).send({ received: true });
        }
    }
}