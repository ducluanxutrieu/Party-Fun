var mongodb = require('mongodb');
var MongoClient = mongodb.MongoClient;
var ip = "139.180.131.30";
var port = "3000";

module.exports = {
	adddish: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				var Menu = db.collection("Menu");
				try {
					let formidable = require('formidable');
					var form = new formidable.IncomingForm();
					form.uploadDir = "./uploads";
					form.keepExtensions = true;
					form.maxFieldsSize = 10 * 1024 * 1024;
					form.multiples = true;
					form.parse(req, function (err2, fields, files) {
						if (files["image"] == undefined || files["image"] == null)
							res.status(400).send({ success: false, message: "No image to upload" });
						else {
							name = fields.name;
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
										dish.rate.average = 0;
										dish.rate.lishRate = [];
										dish.rate.totalpeople = 0;
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
				} catch (e) { console.log(e); }
			})
	},

	update: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				var Menu = db.collection("Menu");
				var ObjectID = require('mongodb').ObjectID;
				if (req.body._id == undefined || ObjectID.isValid(req.body._id) == false) res.status(400).send({ success: false, message: '_ID illegal', dish: null });
				else
					Menu.find({ _id: new ObjectID(req.body._id) }).toArray(function (err, docs) {
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
										if (rel.value == null || err) res.status(400).send({ success: false, message: '_ID not found' });
										else res.status(200).send({ success: true, message: "Update dish success", dish: rel.value })
									})
								} else res.status(400).send({ success: false, message: 'Dish name has existed', dish: null })
							})
						}
						else res.status(400).send({ success: false, message: "_ID dish's has existed ", dish: null });
					})
			})
	},

	uploadimage: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				var Menu = db.collection("Menu");
				let formidable = require('formidable');
				var form = new formidable.IncomingForm();
				form.uploadDir = "./uploads";
				form.keepExtensions = true;
				form.maxFieldsSize = 10 * 1024 * 1024;
				form.multiples = true;
				form.parse(req, function (err2, fields, files) {
					if (files["image"] == undefined || files["image"] == null)
						res.status(400).send({ success: false, message: "No image to upload" });
					else {
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
						var ObjectID = require('mongodb').ObjectID;
						if (fields._id == undefined || ObjectID.isValid(fields._id) == false) res.status(400).send({ success: false, message: "_ID illegal", bill: null });
						else
							Menu.findOneAndUpdate({ _id: new ObjectID(fields._id) }, { $push: { image: { "$each": filename } } }, { returnOriginal: false }, function (err, data) {
								if (err) res.status(400).send({ success: false, message: "Cannot update image. Error is " + err });
								else if (data.value == null) res.status(400).send({ success: false, message: '_ID not found' });
								else res.status(200).send({ success: true, message: "Upload image dish success" })
							})
					}
				})
			})
	},

	deletedish: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				var Menu = db.collection("Menu");
				var ObjectId = require('mongodb').ObjectID;
				if (req.body._id == undefined || ObjectId.isValid(req.body._id) == false) res.status(400).send({ success: false, message: "_ID illegal" });
				else {
					Menu.remove({ _id: new ObjectId(req.body._id) }, function (err, data) {

						if (data == undefined) res.status(400).send({ success: false, message: '_ID not found' });
						else res.status(200).send({ success: true, message: "Delete success" });
					})
				}
			})
	},
	deletebill: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				var Bill = db.collection("Bill");
				var ObjectId = require('mongodb').ObjectID;
				if (req.body._id == undefined || ObjectId.isValid(req.body._id) == false) res.status(400).send({ success: false, message: "_ID illegal" });
				else {
					Bill.remove({ _id: new ObjectId(req.body._id) }, function (err, data) {
						if (!data || err) res.status(400).send({ success: false, message: "_ID not found" });
						else res.status(200).send({ success: true, message: 'Delete bill success' });
					})
				}
			})
	},
	findallbill: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				var Bill = db.collection("Bill");
				Bill.aggregate([
					{
						$sort: { _id: -1 }
					},
					{
						$lookup: {
							from: "User",
							localField: "username",
							foreignField: "username",
							as: "user"
						}
					},
					{
						$addFields: {
							phoneNumber: "$user.phoneNumber",
							email: "$user.email",
						}
					},
					{
						$project: {
							user: 0,
						}
					},
					{
						$unwind: "$phoneNumber"
					},
					{
						$unwind: "$email"
					},
					{
						$limit: 20
					}
				]).toArray(function (err, data) {
					if (data == undefined || data.length == 0) res.status(200).send('No bill');
					else res.status(200).send(data);
				})
			})
	},
	finddish: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				var collection = db.collection("Menu");
				collection.find({}).toArray(function (err, docs) {
					res.status(200).send({ success: true, message: "Get menu success", lishDishs: docs });
				})
			})
	},
	getdish: function (req, res) {
		MongoClient.connect('mongodb://localhost/Android_Lab',
			function (err, db) {
				var Menu = db.collection("Menu");
				var ObjectId = require('mongodb').ObjectID;
				if (req.body._id == undefined || ObjectId.isValid(req.body._id) == false) res.status(400).send({ success: false, message: '_ID illegal', dish: null });
				else Menu.find({ _id: new ObjectId(req.body._id) }).toArray(function (err, docs) {
					if (docs.length == 0) res.status(400).send({ success: false, message: '_id dish not found', dish: null });
					else res.status(200).send({ success: true, message: 'Get item dish success', dish: docs[0] });
				})
			})
	},
	book: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				var Menu = db.collection("Menu");
				var Bill = db.collection("Bill");
				var bill = new Object();
				bill.lishDishs = req.body.lishDishs;
				bill.dateParty = req.body.dateParty;
				bill.numbertable = req.body.numbertable;
				bill.username = req.body.username;
				var date = new Date();
				bill.createAt = date.toLocaleString();
				bill.paymentstatus = false;
				bill.totalMoney = Number('0');
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
							Menu.find({ _id: new ObjectId(id) }).toArray(function (err, data) {
								if (err) throw err;
								if (data.length == 0) res.status(400).send({ success: false, message: '_ID Dish is not valid', bill: null });
								else resolve(data[0].name);
							})
						})
					}
					for (var i = 0; i < bill.lishDishs.length; i++) {
						var numberDish = bill.lishDishs[i].numberDish;
						var price = await myPromise(bill.lishDishs[i]._id);
						bill.lishDishs[i].name = await insertname(bill.lishDishs[i]._id);
						bill.totalMoney += Number(price) * Number(numberDish);
					}
					bill.totalMoney *= req.body.numbertable;
					bill.userpayment = null;
					bill.paymentAt = null;
					Bill.insert(bill, function (err, doc) {
						if (err) res.status(500).send({ success: false, message: err, bill: null });
						var id = doc.insertedIds;
						Bill.find({ _id: id[0] }).toArray(function (err, reslt) {
							res.status(200).send({ success: true, message: "Booking success", bill: reslt[0] });
						})
					})
				}
				book();
			})
	},

	pay: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				var Bill = db.collection("Bill");
				console.log(req.connection.remoteAddress + "Thanh toan");
				var date = new Date();
				var paymentAt = date;
				var userpayment = req.body.username;
				var ObjectId = require('mongodb').ObjectID;
				if (ObjectId.isValid(req.body._id) == false) res.status(400).send({ success: false, message: "_ID illegal", bill: null });
				else {
					Bill.find({ _id: new ObjectId(req.body._id) }).toArray(function (err, reslt) {
						if (reslt.length == 0) res.status(400).send({ success: false, message: "Bill ID not found", bill: null });
						else if (reslt[0].paymentstatus == true) res.status(400).send({ success: false, message: "The bill has been paid", bill: null });
						else {
							Bill.findOneAndUpdate({ _id: new ObjectId(req.body._id) }, { $set: { paymentAt: paymentAt, paymentstatus: true, userpayment: userpayment } }, { returnOriginal: false }, function (err, resl) {
								if (err) res.status(500).send({ success: false, message: "Error", bill: resl });
								else res.status(200).send({ success: true, message: "Pay success", bill: resl.value });
							})
						}
					})
				}
			})
	},

	findbill: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
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
	statisticalmoney: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				var Bill = db.collection("Bill");
				Bill.aggregate([
					{
						$match: {
							"paymentstatus": true,
						}
					},
					{
						$group: {
							_id: {
								day: { $dayOfMonth: "$paymentAt" },
								month: { $month: "$paymentAt" },
								year: { $year: "$paymentAt" },
							},
							totalMoney: { $sum: "$totalMoney" },
							count_of_bill: { $sum: 1 }
						},
					},
					{
						$project: {
							_id: 0,
							dateDay: {
								$concat: [
									{ $substr: ["$_id.month", 0, 2] }, "/",
									{ $substr: ["$_id.day", 0, 2] }, "/",
									{ $substr: ["$_id.year", 0, 4] }
								]
							},
							totalMoney: 1,
							count_of_bill: 1
						}
					},
					//{	
					//	$sort: {"paymentAt": -1}
					//}, 
					{
						$limit: 7
					}

				]).toArray(function (err, data) {
					if (data == undefined || data.length == 0) res.status(200).send("No bill has been paid yet");
					else res.status(200).send(data);
				})
			})
	},
	statisticaldish: function (req, res) {
		MongoClient.connect('mongodb://localhost/Android_Lab', function (err, db) {
			var Bill = db.collection("Bill");
			var datenow = new Date().toLocaleDateString();
			Bill.aggregate([
				{
					$match: {
						"paymentstatus": true,
						"paymentAt": { $gte: new Date(datenow) }
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
							lishDishID: "$lishDishs._id",
							namedish: "$lishDishs.name"
						},
						count_of_bill: { $sum: 1 },
						totalorderbill: { $sum: { $multiply: ["$lishDishs.numberDish", "$numbertable"] } },
					},
				},
				{
					$project: {
						_id: 0,
						count_of_bill: 1,
						totalorderbill: 1,
						IDDish: "$_id.lishDishID",
						name: "$_id.namedish",
						dateDay: {
							$concat: [
								{ $substr: ["$_id.month", 0, 2] }, "/",
								{ $substr: ["$_id.day", 0, 2] }, "/",
								{ $substr: ["$_id.year", 0, 4] }
							]
						},
					}
				},
				{
					$sort: { totalorderdish: -1 }
				},
			]).toArray(function (err, data) {
				if (data == undefined || data.length == 0) res.status(200).send("No bill has been paid yet");
				else res.status(200).send(data);
			})
		})
	},

	rate: function (req, res) {
		MongoClient.connect(
			'mongodb://localhost/Android_Lab',
			function (err, db) {
				var User = db.collection('User');
				var Menu = db.collection('Menu');
				var ObjectId = require('mongodb').ObjectID;
				if (req.body._id == undefined || ObjectId.isValid(req.body._id) == false) res.status(400).send({ success: false, message: "_ID illegal", dish: null });
				else {
					Menu.find({ _id: new ObjectId(req.body._id) }).toArray(function (err, data) {
						if (err || data.length == 0) res.status(400).send({ success: false, message: "Dish ID not found", dish: null });
						else User.find({ username: req.body.username }).toArray(function (err, datauser) {
							var objrate = data[0].rate;
							var rate = new Object();
							rate.username = req.body.username;
							rate.imageurl = datauser[0].imageurl;
							rate._iddish = data[0]._id;
							if (req.body.scorerate == undefined || isNaN(Number(req.body.scorerate)) ||
								Number(req.body.scorerate) < 1 || Number(req.body.scorerate) > 5) res.status(400).send({ success: false, message: "Diem so danh gia phai la so nguyen, co gia tri tu 1 den 5", dish: null });
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
									objrate.average = Math.floor(100 * (objrate.average * objrate.totalpeople + rate.scorerate) / (objrate.totalpeople + 1)) / 100; objrate.totalpeople++;
								}
								else {
									rate.updateAt = date.toLocaleString();
									rate.createAt = check.createAt;
									objrate.lishRate[findindex] = rate;
									objrate.average = objrate.average + Math.floor(100 * (rate.scorerate - check.scorerate) / (objrate.totalpeople)) / 100;
								}
								Menu.findOneAndUpdate({ _id: new ObjectId(req.body._id) }, { $set: { rate: objrate } }, { returnOriginal: false }, function (err, data) {
									if (err) res.status(500).send({ success: false, message: "Error: " + err, dish: null });
									else res.status(200).send({ success: true, message: "Success", dish: data.value });
								})
							}
						})
					})
				}
			})
	}
}
