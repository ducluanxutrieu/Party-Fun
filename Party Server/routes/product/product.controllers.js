var mongodb = require('mongodb');
var bodyParser = require('body-parser');// dung khai bao de doc res.body
var jwt = require('jsonwebtoken');
var config = require('../../config');
var fs = require('fs');
var nodemailer = require('nodemailer');
var MongoClient = mongodb.MongoClient;
var multer = require('multer');
var upload = multer();
var ip = "localhost";
var port = "3000";

module.exports = {
	// tao mon an, gồm các trường
	// name: tên món ăn
	// discription: mô tả về món ăn
	// price: giá tiền
	// type: loại món ăn
	//discount: giảm giá
	//image: ảnh
	// rate: đánh giá món ăn
	adddish: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				if (err) console.log("Unable to connect")
				var User = db.collection("User");
				var Menu = db.collection("Menu");

				let formidable = require('formidable');
				var form = new formidable.IncomingForm();
				form.uploadDir = "./uploads";   // thu muc luu
				form.keepExtensions = true;     // duoi file
				form.maxFieldsSize = 10 * 1024 * 1024;  // kich thuoc
				form.multiples = true; //cho phep gui nhieu file

				form.parse(req, function (err2, fields, files) {
					if (files["image"] == undefined || files["image"] == null)
						res.status(400).send({ success: false, message: "No image to upload" });
					else {
						console.log(req.connection.remoteAddress + "Add dish. Content: " + fields.name);
						name = fields.name;
						console.log(files["image"].type);
						var arrayofFiles = files["image"];
						if (arrayofFiles.length > 0) {
							var filename = [];
							arrayofFiles.forEach((eachFile) => {
								if (eachFile.type.match(/.(jpg|jpeg|png|form-data)$/i) == null) res.status(400).send({ success: false, message: "You are only allowed to upload image files ending in .jpg .jpeg .png" });
								else filename.push("http://" + ip + ":" + port + "/open_image?image_name=" + eachFile.path.slice(8));
							})
						}
						else {
							var filename = [];
							if (files["image"].type.match(/.(jpg|jpeg|png|form-data)$/i) == null) res.status(400).send({ success: false, message: "You are only allowed to upload image files ending in .jpg .jpeg .png" });
							else filename.push("http://" + ip + ":" + port + "/open_image?image_name=" + files["image"].path.slice(8));
						}
						Menu.find({ name: name }).toArray(function (err, docs) {
							if (Array.isArray(docs) && docs.length == 0) {
								var dish = new Object();
								if (fields.name == undefined || fields.description == undefined || fields.price == undefined || fields.type == undefined || fields.discount == undefined ||
									isNaN(Number(fields.discount)) || Number(fields.discount) < 0 || Number(fields.discount >= 100) || isNaN(Number(fields.price)) || Number(fields.price <= 0))
									res.status(400).send({ success: false, message: "The submitted values ​​are not in the correct format", dish: null });
								else {
									dish.name = fields.name;
									dish.description = fields.description;
									dish.price = fields.price;
									dish.type = fields.type;
									dish.discount = fields.discount;
									dish.image = filename;
									var date = new Date();
									dish.updateAt = date.toLocaleString();
									dish.createAt = dish.updateAt;
									dish.usercreate = req.body.username;
									dish.price = Number(dish.price);
									dish.discount = Number(dish.discount);
									dish.rate = new Object();
									dish.rate.average = 0;	// diem so trung binh danh gia, tu 1->5
									dish.rate.lishRate = [];	// danh sach mang luu tru thong tin moi nguoi danh gia
									dish.rate.totalpeople = 0; // tong so nguoi danh gia
									Menu.insert(dish, function (err, rel) {
										if (err) res.status(500).send({ success: "false", message: err, dish: null });
										else Menu.find({
											name: name
										}).toArray(function (err, docc) {
											res.status(200).send({
												success: true, message: "Add dish success", dish: docc[0]
											})
										})
									})
								}
							}
							else res.status(400).send({ success: false, message: "Dish's name has existed", dish: null });
						})
					}
				})
			})
	},

	//update thông tin món ăn
	update: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				if (err) console.log("Unable to connect")
				var User = db.collection("User");
				var Menu = db.collection("Menu");
				console.log(req.connection.remoteAddress + "Update infor dish. Content:" + JSON.stringify(req.body));
				var ObjectID = require('mongodb').ObjectID;
				if (req.body._id == undefined || ObjectID.isValid(req.body._id) == false) res.status(400).send({ success: false, message: "_ID illegal", dish: null });
				else Menu.find({ _id: new ObjectID(req.body._id) }).toArray(function (err, docs) {
					if (Array.isArray(docs) && docs.length != 0) {
						var date = new Date();
						var dish = req.body;
						dish.updateAt = date.toLocaleString();
						const entries = Object.keys(dish)
						const updates = {}
						for (let i = 0; i < entries.length; i++) {
							updates[entries[i]] = Object.values(req.body)[i]
						}
						delete updates._id;
						Menu.find({ name: req.body.name }).toArray(function (err, data) {
							if (data.length == 0 || (data.length == 1 && data[0]._id.toString() == req.body._id)) {
								Menu.findOneAndUpdate({ _id: new ObjectID(req.body._id) }, { $set: updates }, { returnOriginal: false }, function (err, rel) {
									if (err) res.status(500).send({ success: "false", message: err, dish: null });
									else if (rel.value == null) res.status({ success: false, message: "_ID not found", dish: null });
									else res.status(200).send({ success: true, message: "Update dish success ", dish: rel.value });
								})
							}
							else res.status(400).send({ success: false, message: "Dish's name has existed", dish: null })
						})
					}
					else res.status(400).send({ success: false, message: "Dish's name has existed ", dish: null });
				})
			})
	},

	//thêm danh sách ảnh vào trong món ăn
	uploadimage: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				if (err) console.log("Unable to connect")
				var User = db.collection("User");
				var Menu = db.collection("Menu");
				console.log(req.connection.remoteAddress + "Upload image dish");

				let formidable = require('formidable');
				var form = new formidable.IncomingForm();
				form.uploadDir = "./uploads";   // thu muc luu
				form.keepExtensions = true;     // duoi file
				form.maxFieldsSize = 10 * 1024 * 1024;  // kich thuoc
				form.multiples = true; //cho phep gui nhieu file

				form.parse(req, function (err2, fields, files) {
					if (files["image"] == undefined || files["image"] == null)
						res.status(400).send({ success: false, message: "No image to upload" });
					else {
						var arrayofFiles = files["image"];
						if (arrayofFiles.length > 0) {
							var filename = [];
							arrayofFiles.forEach((eachFile) => {
								if (eachFile.type.match(/.(jpg|jpeg|png)$/i) == null) res.status(400).send({ success: false, message: "You are only allowed to upload image files ending in .jpg .jpeg .png" });
								else filename.push("http://" + ip + ":" + port + "/open_image?image_name=" + eachFile.path.slice(8));
							})
						}
						else {
							var filename = [];
							if (files["image"].type.match(/.(jpg|jpeg|png)$/i) == null) res.status(400).send({ success: false, message: "You are only allowed to upload image files ending in .jpg .jpeg .png" });
							else filename.push("http://" + ip + ":" + port + "/open_image?image_name=" + files["image"].path.slice(8));
						}
						var ObjectID = require('mongodb').ObjectID;
						if (fields._id == undefined || ObjectID.isValid(fields._id) == false) res.status(400).send({ success: false, message: "_ID illegal", bill: null });
						else
							Menu.update({ _id: new ObjectID(fields._id) }, { $push: { image: { "$each": filename } } }, function (err, data) {
								if (err) res.status(400).send({ success: false, message: "Cannot update image. Error is " + err });
								else if (data.value == null) res.status(400).send({ success: false, message: "_ID not found" });
								else res.status(200).send({ success: true, message: "Upload image dish success" })
							})
					}
				})
			})
	},
	// delete mon an
	// _id: _id món ăn cần xóa
	deletedish: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				if (err) console.log("Unable to connect")
				var User = db.collection("User");
				var Menu = db.collection("Menu");
				console.log(req.connection.remoteAddress + "Delete dish. Content: " + req.body._id);
				var ObjectId = require('mongodb').ObjectID;
				if (req.body._id == undefined || ObjectId.isValid(req.body._id) == false) res.status(400).send({ success: false, message: "_ID illegal" });
				else {
					Menu.remove({ _id: new ObjectId(req.body._id) }, function (err, data) {
						if (data.value == null) res.status(400).send({ success: false, message: "_ID not found" });
						else res.status(200).send({ success: true, message: "Delete success" });
					})
				}
			})
	},

	// xuat thong tin danh sach mon an
	finddish: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				if (err) console.log("Unable to connect")
				var collection = db.collection("Menu");
				console.log(req.connection.remoteAddress + "Xuat thong tin mon an");
				collection.find({}).toArray(function (err, docs) {
					res.status(200).send({ success: true, message: "Get menu success", lishDishs: docs });
				})
			})
	},
	getdish: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				if (err) console.log("Unable to connect")
				var collection = db.collection("Menu");
				console.log(req.connection.remoteAddress + "Xuat thong tin cua mon an do");
				var ObjectId = require('mongodb').ObjectID;
				if (req.body._id == undefined || ObjectId.isValid(req.body._id) == false) res.status(400).send({ success: false, message: "_ID illegal", dish: null });
				else collection.find({ _id: new ObjectId(req.body._id) }).toArray(function (err, docs) {
					if (docs.length == 0) res.status(400).send({ success: false, message: "_id dish not found", dish: null });
					else res.status(200).send({ success: true, message: "Get item dish success", dish: docs });
				})
			})
	},
	// dat ban
	book: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				if (err) console.log("Unable to connect")
				var Menu = db.collection("Menu");
				var User = db.collection("User");
				var Bill = db.collection("Bill");
				console.log(req.connection.remoteAddress + "Booking dish");
				// khai bao bien
				var bill = new Object();
				bill.lishDishs = req.body.lishDishs;
				bill.dateParty = req.body.dateParty;
				bill.numbertable = req.body.numbertable;
				bill.username = req.body.username;
				var date = new Date();
				bill.createAt = date.toLocaleString();
				bill.paymentstatus = false;   //trang thai thanh toan
				bill.totalMoney = Number('0'); // tien
				var book = async () => {


					bill.lishDishs = req.body.lishDishs;
					var ObjectId = require('mongodb').ObjectID;
					var myPromise = (reqname) => {
						return new Promise((resolve, reject) => {

							Menu.find({ _id: new ObjectId(reqname) })
								.toArray(function (err, data) {
									if (err) throw err;
									if (data.length == 0) res.status(400).send({ success: false, message: "_ID Dish is not valid", bill: null });
									else resolve(data[0].price - Math.floor(data[0].price * data[0].discount / 100));
								});
						});
					};
					var insertname = (id) => {
						return new Promise((resolve, reject) => {

							Menu.find({ _id: new ObjectId(id) })
								.toArray(function (err, data) {
									if (err) throw err;
									if (data.length == 0) res.status(400).send({ success: false, message: "_ID Dish is not valid", bill: null });
									else resolve(data[0].name);
								});
						})
					}
					// tinh tong so tien tra
					for (var i = 0; i < bill.lishDishs.length; i++) {
						var numberDish = bill.lishDishs[i].numberDish;
						var price = await myPromise(bill.lishDishs[i]._id);
						bill.lishDishs[i].name = await insertname(bill.lishDishs[i]._id);
						bill.totalMoney += Number(price) * Number(numberDish);
					}
					bill.totalMoney *= req.body.numbertable;
					bill.userpayment = null;
					bill.paymentAt = null;
					// them vao database bill
					Bill.insert(bill, function (err, doc) {
						if (err) res.status(500).send({ success: false, message: err, bill: null });
						User.aggregate([{
							$lookup: {
								from: "Bill",
								localField: "username",
								foreignField: "username",
								as: "userCart"
							}
						},
						{
							$out: "User"
						}]).toArray(function (err, data) {
							if (err) res.status(500).send({ success: false, message: err, bill: null });
						})
						var id = doc.insertedIds;
						// xuat thong tin hoa don
						Bill.find({ _id: id[0] }).toArray(function (err, reslt) {
							res.status(200).send({ success: true, message: "Booking success", bill: reslt[0] });
						})
					})
				}
				book();
			})
	},

	// thanh toan
	// _id: _id bill muốn thanh toán
	pay: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				if (err) console.log("Unable to connect")
				var Menu = db.collection("Menu");
				var User = db.collection("User");
				var Bill = db.collection("Bill");
				console.log(req.connection.remoteAddress + "Thanh toan");
				var date = new Date();
				var paymentAt = date;
				var userpayment = req.body.username;
				var ObjectId = require('mongodb').ObjectID;
				// nhan vien moi thanh toan duoc
				if (ObjectId.isValid(req.body._id) == false) res.status(400).send({ success: false, message: "_ID illegal", bill: null });
				else {
					Bill.find({ _id: new ObjectId(req.body._id) }).toArray(function (err, reslt) {
						if (reslt.length == 0) res.status(400).send({ success: false, message: "Bill ID not found", bill: null });
						else if (reslt[0].paymentstatus == true) res.status(400).send({ success: false, message: "The bill has been paid", bill: null });
						else {
							Bill.update({ _id: new ObjectId(req.body._id) }, { $set: { paymentAt: paymentAt, paymentstatus: true, userpayment: userpayment } }, function (err, resl) {
								if (err) res.status(500).send({ success: false, message: "Error", bill: resl });
							})
							User.aggregate([{
								$lookup: {
									from: "Bill",
									localField: "username",
									foreignField: "username",
									as: "userCart"
								}
							},
							{
								$out: "User"
							}]).toArray(function (err, data) {
								if (err) res.status(500).send({ success: false, message: err, bill: null });
							});

							Bill.find({ _id: new ObjectId(req.body._id) }).toArray(function (err, reslt) {
								if (reslt.length == 0) res.status(400).send({ success: false, message: "Can't find Bill", bill: null });
								res.status(200).send({ success: true, message: "Pay success", bill: reslt[0] });
							})
						}
					})
				}
			});
	},
	// tìm trong database xem user có bill nào chưa thanh toán, xuất ra thông tin bill mà user chưa thanh toán
	// đăng nhập username của nhân viên
	// req gửi lên name: tên username của khách hàng yêu cầu
	findbill: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				if (err) console.log("Unable to connect")

				var User = db.collection("User");
				var Bill = db.collection("Bill");
				if (req.body.name) {
					Bill.find({ username: req.body.name, paymentstatus: false }).toArray(function (err, data) {
						if ((err) || (data.length == 0))
							res.status(400).send({ success: false, message: "Find not found Bill", bill: null });
						else res.status(200).send({ success: true, message: "Find success", bill: data });
					})
				}
				else res.status(400).send({ success: false, message: "name is exists", bill: null });
			})
	},
	// thống kê
	statistical: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				if (err) console.log("Unable to connect")
				// thống kê xem trong vòng 1 ngày, số tiền thu được là bao nhiêu(totalMoney), tiền đó thu từ bao nhiêu bill(count_of_bill),
				// _id món ăn có order trong ngày, tổng số lượt món ăn đó được order(totalorderdish), ngày thống kê.
				var Bill = db.collection("Bill");
				Bill.aggregate([
					{
						$match: {
							"paymentstatus": true
						}
					},
					{
						$unwind: "$lishDishs"
					},
					{
						$group: {
							_id: {
								day: { $dayOfMonth: "$paymentAt" },
								month: { $month: "$paymentAt" },
								year: { $year: "$paymentAt" },
								lishDishsID: "$lishDishs._id",
							},
							totalMoney: { $sum: "$totalMoney" },	// tổng tiền thu được thống kê theo ngày
							count_of_bill: { $sum: 1 },				//số bill thống kê theo ngày
							totalorderdish: { $sum: { $multiply: ["$lishDishs.numberDish", "$numbertable"] } }, // số lần món ăn đó được gọi( đã nhân số bàn)
							namedish: { $first: "$lishDishs.name" }
						},
					},
					{
						$project: {
							_id: 0,
							dateDay: {
								$concat: [
									{ $substr: ["$_id.day", 0, 2] }, "-",
									{ $substr: ["$_id.month", 0, 2] }, "-",
									{ $substr: ["$_id.year", 0, 4] }
								]
							},
							totalMoney: 1,
							count_of_bill: 1,
							totalorderdish: 1,
							IDDish: {
								$toObjectId: "$_id.lishDishsID"
							},
							namedish: 1
						}
					},

				]).toArray(function (err, data) {
					console.log(data);
					res.status(200).send(data);
				})
			})
	},
	// danh gia mon an
	// nguoi gui: username
	// _id món ăn 
	// muc do rate: scorerate: điểm số đánh giá, từ 1 đến 5
	// nội dung đánh giá: content
	// ngày tạo
	rate: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				if (err) console.log("Unable to connect")
				var User = db.collection('User');
				var Menu = db.collection('Menu');
				var ObjectId = require('mongodb').ObjectID;
				if (req.body._id == undefined || ObjectId.isValid(req.body._id) == false) res.status(400).send({ success: false, message: "_ID illegal", dish: null });
				else {
					Menu.find({ _id: new ObjectId(req.body._id) }).toArray(function (err, data) {
						if (err || data.length == 0) res.status(400).send({ success: false, message: "Dish ID not found", dish: null });
						else {
							var objrate = data[0].rate;
							var rate = new Object();
							rate.username = req.body.username;
							rate._iddish = data[0]._id;
							if (req.body.scorerate == undefined || isNaN(Number(req.body.scorerate)) ||
								Number(req.body.scorerate) < 1 || Number(req.body.scorerate) > 5) res.status(400).send({ success: false, message: "Diem so danh gia phai la so nguyen, co gia tri tu 1 den 5", dish:null });
							else {
								rate.scorerate = Number(req.body.scorerate);
								rate.content = req.body.content;
								var date = new Date();

								function isArr(fruit) {
									return fruit.username == req.body.username;
								}
								var findindex = objrate.lishRate.findIndex(isArr);
								var check = objrate.lishRate.find(isArr);
								if (check == undefined) {
									rate.createAt = date.toLocaleString();
									rate.updateAt = date.toLocaleString();
									objrate.lishRate.push(rate);
									objrate.average = Math.floor(100 * (objrate.average * objrate.totalpeople + rate.scorerate) / (objrate.totalpeople + 1)) / 100;
									objrate.totalpeople++;
								}
								else {
									rate.updateAt = date.toLocaleString();
									rate.createAt=check.createAt;
									objrate.lishRate[findindex] = rate;
									objrate.average = objrate.average + Math.floor(100 * (rate.scorerate-check.scorerate) / (objrate.totalpeople)) / 100;	
								}
								
								// sua o day + them dish vao res
								Menu.findOneAndUpdate({ _id: new ObjectId(req.body._id) }, { $set: { rate: objrate } }, { returnOriginal: false }, function (err, data) {
									if (err) res.status(500).send({ success: false, message: "Error: " + err, dish: null });
									else res.status(200).send({ success: true, message: "Success", dish: data.value });
								})
							}
						}
					})
				}
			})
	},
}