var mongodb = require('mongodb');
var MongoClient = mongodb.MongoClient;
var ip = "localhost";
var port = "3000";
var khongdau = require('khong-dau');
var ObjectId =  require('mongodb').ObjectId;
var cheerio = require('cheerio');
var osu = require('node-os-utils');

module.exports = {
	// thêm món ăn
	add_dish: function (req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Menu = db.collection("Menu");
				if (!req.body.name) res.status(400).send({ message: "Trường name không được rỗng", data: "true" });
				else if (!req.body.description) res.status(400).send({ message: "Trường mô tả không được rỗng", data: "true" });
				else if (!req.body.price) res.status(400).send({ message: "Trường giá tiền không được rỗng", data: "true" });
				else if (!req.body.currency) res.status(400).send({ message: "Trường đơn vị tiền tệ không được rỗng", data: "true" });
				else if (!req.body.categories) res.status(400).send({ message: "Trường chuyên mục không được rỗng", data: "true" })
				else if (!req.body.discount) res.status(400).send({ message: "Trường giảm giá không được rỗng", data: "true" })
				else if (!req.body.image) res.status(400).send({message: "Trường list ảnh không được rỗng", data: "false"});
				else Menu.findOne({ name: req.body.name }, function (err, docs) {
					if (!docs) {
						try {
							req.body.image = JSON.parse(req.body.image);
							req.body.categories = JSON.parse(req.body.categories);
						}
						catch (e) {
							console.log(e);
							if (!Array.isArray(req.body.image)) req.body.image = [];
							if (!Array.isArray(req.body.categories)) req.body.categories = [];
						}
						if (!req.body.feature_image && req.body.image.length != 0) req.body.feature_image = req.body.image[0];
						req.body.create_at = req.body.update_at = new Date();
						req.body.user_create = req.body.username;
						Menu.insertOne(req.body, function (err, rel) {
							if (err) {
								res.status(500).send({ message: "Lỗi khi insert database món ăn", data: "true" });
								console.log(err);
							}
							else
								res.status(200).send({
									message: "Thêm món ăn thành công", data: rel.ops[0]
								})
						})
					}
					else res.status(400).send({ message: "Tên món ăn đã tồn tại", data: "true" });
				})
			})
	},
	// cập nhật món ăn
	update_dish: function (req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Menu = db.collection("Menu");
				if (!req.body._id || ObjectId.isValid(req.body._id) == false) res.status(400).send({ message: 'ID món ăn không được rỗng', data: "true" });
				else
					Menu.findOne({ _id: new ObjectId(req.body._id) }, function (err, data) {
						if (data) {
							Menu.findOne({ name: req.body.name }, function (err, exists) {
								if (exists && exists._id.toString() != req.body._id.toString()) res.status(400).send({ message: "Tên món ăn đã được sử dụng", data: "true" })
								else {
									var dish = req.body;
									dish.update_at = new Date();
									dish.price = Number(dish.price);
									try {
										dish.categories = JSON.parse(dish.categories);
										dish.image = JSON.parse(dish.image);
									}
									catch(e) {
										console.log(e);
										if (!Array.isArray(dish.image)) dish.image = [];
										if (!Array.isArray(dish.categories)) dish.categories = [];
									}
									if (!Array.isArray(dish.categories)) dish.categories = [dish.categories];
									const entries = Object.keys(dish)
									const updates = {}
									for (let i = 0; i < entries.length; i++) {
										updates[entries[i]] = Object.values(req.body)[i]
									}
									delete updates._id;
									updates.update_at = new Date();
									Menu.findOneAndUpdate({ _id: new ObjectId(req.body._id) }, { $set: updates }, { returnOriginal: false }, function (err, rel) {
										if (rel.value == null || err) res.status(400).send({ message: 'Lỗi khi cập nhật món ăn', data: "true" });
										else res.status(200).send({ message: "Cập nhật món ăn thành công", data: rel.value })
									})
								}
							})
						}
						else res.status(400).send({ message: "ID món ăn không tồn tại", data: "true" });
					})
			})
	},

	// xóa món ăn
	del_dish: function (req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Menu = db.collection("Menu");
				if (req.body._id == undefined || ObjectId.isValid(req.body._id) == false) res.status(400).send({ message: "ID món ăn không được rỗng", data: "true" });
				else {
					Menu.remove({ _id: new ObjectId(req.body._id) }, function (err, data) {
						if (err || !data) res.status(400).send({ message: 'Lỗi khi xóa món ăn', data: "true" });
						else res.status(200).send({ message: "Xóa món ăn thành công", data: "true" });
					})
				}
			})
	},
	// hủy đơn
	del_bill: function (req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Bill = db.collection("Bill");
				if (req.params.id == undefined || ObjectId.isValid(req.params.id) == false) res.status(400).send({ message: "ID Bill không hợp lệ", data: "false" });
				else {
					if (!req.body.note) req.body.note = "";
					Bill.findOneAndUpdate({ _id: new ObjectId(req.params.id) }, {
						$set: {
							confirm_status: 2, confirm_at: new Date(), confirm_by: req.body.username,
							confirm_note: req.body.note
						}
					}, { returnOriginal: false }, function (err, data) {
						if (!data || err || !data.value) res.status(400).send({ message: "Lỗi khi tìm id hóa đơn", data: "false" });
						else res.status(200).send({ message: 'Cập nhật trạng thái hóa đơn thành công', data: data.value });
					})
				}
			})
	},
	// xac nhan hoa đơn
	confirm_bill: function (req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Bill = db.collection("Bill");
				if (req.params.id == undefined || ObjectId.isValid(req.params.id) == false) res.status(400).send({ message: "ID Bill không hợp lệ", data: "false" });
				else {
					if (!req.body.note) req.body.note = "";
					Bill.findOneAndUpdate({ _id: new ObjectId(req.params.id) }, {
						$set: {
							confirm_status: 1, confirm_at: new Date(), confirm_by: req.body.username,
							confirm_note: req.body.note
						}
					}, { returnOriginal: false }, function (err, data) {
						if (!data || err || !data.value) res.status(400).send({ message: "Lỗi khi tìm id hóa đơn", data: "false" });
						else res.status(200).send({ message: 'Cập nhật trạng thái hóa đơn thành công', data: data.value });
					})
				}
			})
	},
	list_bill: function (req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			async function (err, db) {
				var Bill = db.collection("Bill");
				if (!req.query.page || req.query.page < 1) req.query.page = 1;
				let total_page = (await Bill.find({}).toArray()).length;
                total_page = Math.ceil(total_page / 10);
				Bill.find({}).sort({ date_party: -1 }).limit(10).skip(10 * (req.query.page - 1))
					.toArray(function (err, data) {
						if (err || !data) res.status(400).send({message: "Không tìm thấy bill", data: "false"});
						else res.status(200).send({message: "Lấy danh sách hóa đơn", data: {
							total_page: total_page,
							start: 10 * (req.query.page -1),
							end: (10 * (req.query.page) -1),
							value: data,
						}});
					})
			})
	},
	// lấy danh sách món ăn 
	get_list_dish: function (req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				if (err) console.log(err);
				var collection = db.collection("Menu");
				var user = db.collection("User");
				user.find({}).toArray(function(err, data) {
					for (let index of data) {
						user.update({username: index.username}, {$set: {birthday: new Date(index.birthday)}})
					}
				})
				collection.find({})
				.toArray(function (err, docs) {
					if (docs && docs.length!=0) {
						for(let index of docs) {
							index.price_new = index.price - Math.ceil((index.price*index.discount)/100);
						}
					} 
					res.status(200).send({ message: "Lấy danh sách món ăn", data: docs });
				})
			})
	},
	// lấy danh sách món ăn theo chuyên mục
	get_list_dish_by_categories: function (req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			async function (err, db) {
				if (err) console.log(err);
				var collection = db.collection("Menu");
				if (!req.query.page || req.query.page < 1) req.query.page = 1;
				let total_page = (await collection.find({categories: req.query.categories}).toArray()).length;
                total_page = Math.ceil(total_page / 10);
				collection.find({ categories: req.query.categories}).limit(10).skip(10 * (req.query.page - 1))
					.toArray(function (err, docs) {
						for(let index of docs) {
							index.price_new = index.price - Math.ceil((index.price*index.discount)/100);
						}
						res.status(200).send({ message: "Lấy danh sách món ăn theo categories " + req.query.categories, data: {
							total_page: total_page,
							start: 10 * (req.query.page -1),
							end: (10 * (req.query.page) -1),
							value: docs,
						} });
					})
			})
	},
	// lấy thông tin 1 món ăn
	get_dish: function (req, res) {
		MongoClient.connect('mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Menu = db.collection("Menu");
				if (req.params.id == undefined || ObjectId.isValid(req.params.id) == false) 
					res.status(400).send({ message: 'ID món ăn không được rỗng', data: "true" });
				else Menu.findOne({ _id: new ObjectId(req.params.id) }, function (err, data) {
					if (!data || err) res.status(400).send({ message: 'ID món ăn không chính xác', data: "true" });
					else 
					{
						data.price_new = data.price - Math.ceil((data.price*data.discount)/100);
						res.status(200).send({ message: 'Lấy thông tin về món ăn', data: data });
					}
				})
			})
	},
	// Thêm bình luận về món ăn 
	add_rate: function (req, res) {
		MongoClient.connect('mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Menu = db.collection("Menu");
				var Rate = db.collection("Rate_Dish");
				if (req.body.id == undefined || ObjectId.isValid(req.body.id) == false) res.status(400).send({ message: 'ID món ăn không được rỗng', data: "true" });
				else Menu.findOne({ _id: new ObjectId(req.body.id) }, function (err, data) {
					if (!data || err) res.status(400).send({ message: 'ID món ăn không chính xác', data: "true" });
					else {
						req.body.score = Number(req.body.score);
						if (req.body.score < 1) req.body.score = 1;
						if (req.body.score > 5) req.body.score = 5;
						if (!req.body.comment) req.body.comment = null;
						Rate.insertOne({
							id_dish: req.body.id, user_rate: req.body.username, score: req.body.score,
							comment: req.body.comment, create_at: new Date(), update_at: new Date()
						}, function (err, data) {
							if (err || !data) res.status(400).send({ message: "Lỗi khi insert đánh giá món ăn", data: "false" });
							else res.status(200).send({ message: "Đánh giá món ăn thành công", data: data.ops[0] })
						})
					}
				})
			})
	},
	// Chỉnh sửa bình luận về món ăn 
	edit_rate: function (req, res) {
		MongoClient.connect('mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Rate = db.collection("Rate_Dish");
				if (req.body.id == undefined || ObjectId.isValid(req.body.id) == false) res.status(400).send({ message: 'ID đánh giá không được rỗng', data: "true" });
				else {
					req.body.score = Number(req.body.score);
					if (req.body.score < 1) req.body.score = 1;
					if (req.body.score > 5) req.body.score = 5;
					if (!req.body.comment) req.body.comment = null;
					Rate.findOneAndUpdate({ _id: new ObjectId(req.body.id), user_rate: req.body.username }, {
						$set: {
							score: req.body.score,
							comment: req.body.comment, update_at: new Date()
						}
					}, { returnOriginal: false }, function (err, data) {
						if (err || !data || !data.value) res.status(400).send({ message: "Lỗi khi cập nhật đánh giá món ăn hoặc ID không chính xác", data: "false" });
						else res.status(200).send({ message: "Chỉnh sửa đánh giá món ăn thành công", data: data.value })
					})
				}
			})
	},
	del_rate: function (req, res) {
		MongoClient.connect('mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Rate = db.collection("Rate_Dish");
				if (req.body.id == undefined || ObjectId.isValid(req.body.id) == false) res.status(400).send({ message: 'ID món ăn không được rỗng', data: "true" });
				else {
					Rate.remove({ _id: new ObjectId(req.body.id), user_rate: req.body.username }, function (err, data) {
						if (err || !data) res.status(400).send({ message: "Lỗi khi xóa đánh giá món ăn hoặc ID không chính xác", data: "false" });
						else res.status(200).send({ message: "Xóa đánh giá món ăn thành công", data: "true" })
					})
				}
			})
	},
	get_rate: function (req, res) {
		MongoClient.connect('mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Rate = db.collection("Rate_Dish");
				if (req.query.id == undefined || ObjectId.isValid(req.query.id) == false) res.status(400).send({ message: 'ID món ăn không được rỗng', data: "true" });
				else {
					if (!req.query.page || req.query.page <1 ) req.query.page = 1;
					Rate.find({ id_dish: req.query.id }).toArray(function (err, data) {
						if (err || !data) res.status(400).send({ message: "Lỗi khi get bình luận món ăn", data: "false" });
						else {
							let sum_score = 0;
							let count_rate = data.length;
							for (let index of data) {
								if (index.score) sum_score += index.score;
							}
							let avg_rate = Math.ceil((sum_score / count_rate) * 100) / 100;
							Rate.find({ id_dish: req.query.id }).sort({ create_at: -1 })
								.limit(10).skip(10 * (req.query.page - 1))
								.toArray(async function (err, data) {
									if (err) req.status(400).send({ message: "Lỗi khi get bình luận món ăn", data: "false" });
									else
									{
										let User = db.collection("User");
										for (let index of data) {
											index.avatar = (await User.findOne({username : index.user_rate})).avatar;
										}
										res.status(200).send({
											message: "Get bình luận món ăn thành công", data: {
												count_rate: count_rate, avg_rate: avg_rate,
												total_page: Math.ceil(count_rate / 10),
												start: 10 * (req.query.page -1),
												end: (10 * (req.query.page) -1),
												list_rate: data,
											}
										});
									}
								})
						}
					})
				}
			})
	},
	book: function (req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			async function (err, db) {
				var Menu = db.collection("Menu");
				var Bill = db.collection("Bill");
				let total_money = 0;
				for (let dish_bill of req.body.dishes) {
					let { name, feature_image, price, discount, currency } = await Menu.findOne({ _id: new ObjectId(dish_bill._id) });
					dish_bill.name = name;
					dish_bill.feature_image = feature_image;
					dish_bill.price = Number(price);
					dish_bill.discount = Number(discount);
					dish_bill.currency = currency;
					dish_bill.total_money = Math.ceil(dish_bill.price - (dish_bill.price * dish_bill.discount / 100));
					total_money += dish_bill.total_money  * dish_bill.count;
				}
				// phieu giam gia
				var Discount = db.collection('Discount');
				if (req.body.discount_code && req.body.discount_code.length!=0) {
					var discount_money = await Discount.findOne({code: req.body.discount_code});
					if (discount_money && discount_money.expiresIn.getTime() > new Date().getTime()) discount_money = discount_money.discount;
					else {
						discount_money = 0;
						return res.status(400).send({
							message: "The discount code is not valid",
							data: "false"
						})
					}
				}
				else discount_money = 0;
				req.body.total = req.body.table * total_money - (req.body.table * total_money * discount_money / 100); // tong tien 
				req.body.customer = req.body.username;
				req.body.create_at = new Date();
				req.body.confirm_status = 0;
				req.body.confirm_at = new Date();
				req.body.confirm_by = "";
				req.body.confirm_note = "";
				req.body.currency = "vnd";
				req.body.payment_status = 0;
				req.body.payment_type = 0;
				req.body.payment_at = new Date();
				req.body.payment_by = "";
				delete req.body.username;
				delete req.body.discount_code;
				Bill.insertOne(req.body, function (err, doc) {
					if (err || !doc.ops[0]) res.status(500).send({ message: "Lỗi khi đặt món ăn", data: "false" });
					else res.status(200).send({ message: "Booking success", data: doc.ops[0] });
				})
			
			})
	},

	payment: function (req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Bill = db.collection("Bill");
				if (ObjectId.isValid(req.params.id) == false) res.status(400).send({ message: "Id hóa đơn không hợp lệ", data: "false" });
				else {
					Bill.findOneAndUpdate({ _id: new ObjectId(req.params.id), payment_status: 0 }, {
						$set: {
							payment_status: 1, payment_at: new Date(), payment_by: req.body.username,
							payment_type: 0
						}
					}, { returnOriginal: false }, function (err, data) {
						if (err || !data || !data.value) res.status(500).send({ message: "Lỗi không tìm thấy hóa đơn", data: "false" });
						else res.status(200).send({ message: "Thanh toán trực tiếp tại quầy thành công", data: data.value });
						// cap nhat type user khi thanh toán thành công
						var User = db.collection("User");
						Bill.aggregate([
							{
								$match: {
									"customer": data.value.customer,
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
								var user = await User.findOne({username: data.value.customer});
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
									User.update({username: data.value.customer}, {$set: {type: user.type}});
								}
							}
						})
					})
				}
			})
	},
	add_discount_code: function(req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			async function (err, db) {
				var Discount = db.collection("Discount");
				if (req.body.code) {
					if (req.body.expiresIn && req.body.expiresIn.length!=0) {
						req.body.expiresIn = new Date(req.body.expiresIn);
						if (req.body.discount ) {
							req.body.discount = Number(req.body.discount);
							let check_exist = await Discount.findOne({code: req.body.code});
							if (check_exist) res.status({message: "Mã code đã tồn tại trước đó",  data: "false"})
							else {
								Discount.insertOne({code: req.body.code, expiresIn: req.body.expiresIn, discount: req.body.discount, author: req.body.username, create_at: new Date()}, function(err, data) {
									if (err || !data.ops[0]) res.status(500).send({ message: "Lỗi khi tạo mới mã giảm giá", data: "false" });
									else res.status(200).send({ message: "Tạo mã giảm giá thành công", data: data.ops[0] });
								});
							}
						}
						else res.status({message: "Trường mã giảm giá không được rỗng", data: "false"});
					}
					else res.status({message: "Trường ngày hết hạn không được rỗng", data: "false"});
				}
				else res.status({message: "Trường mã giảm giá không được rỗng", data: "false"});
			})
	},
	get_list_discount_code : function(req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			async function (err, db) {
				var Discount = db.collection("Discount");
				Discount.find({}).sort({expiresIn: -1}).toArray(function(err, data) {
					res.status(200).send({message: "Lấy danh sách mã code giảm giá", data: data});
				})
			})
	},
	get_discount_code_of_user: function(req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			async function (err, db) {
				var Discount = db.collection("Discount");
				Discount.find({expiresIn : {$gte: new Date()}}).sort({expiresIn: -1}).toArray(function(err, data) {
					res.status(200).send({message: "Lấy danh sách mã code giảm giá", data: data});
				})
			})
	},
	find_bill_by_id: function (req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Bill = db.collection("Bill");
				if (req.params.name) {
					Bill.find({ customer: req.params.name, payment_status: 0 }).sort({ date_party: -1 }).toArray(function (err, data) {
						if ((err) || (data.length == 0))
							res.status(400).send({ message: "Không tìm thấy dữ liệu", data: "false" });
						else res.status(200).send({ message: "Tìm hóa đơn theo tên khách hàng thành công", data: data });
					})
				}
				else res.status(400).send({ message: "Tên người dùng không được rỗng", data: "false" });
			})
	},
	statistic_money: function (req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Bill = db.collection("Bill");
				Bill.aggregate([
					{
						$match: {
							"payment_status": 1,
						}
					},
					{
						$group: {
							_id: {
								day: { $dayOfMonth: "$payment_at" },
								month: { $month: "$payment_at" },
								year: { $year: "$payment_at" },
							},
							total: { $sum: "$total" },
							count: { $sum: 1 }
						},
					},
					{
						$project: {
							_id: {
								$concat: [
									{ $substr: ["$_id.month", 0, 2] }, "/",
									{ $substr: ["$_id.day", 0, 2] }, "/",
									{ $substr: ["$_id.year", 0, 4] }
								]
							},
							total: 1,
							count: 1
						}
					},
					{
						$sort: { _id: 1 }
					},
					{
						$limit: 7
					}
				]).toArray(function (err, data) {
					if (err) res.status(400).send({ message: "Lỗi khi thống kê hóa đơn theo ngày", data: "false" });
					else res.status(200).send({ message: "Thống kê tổng hóa đơn theo 7 ngày gần nhất", data: data });
				})
			})
	},
	// thống kê món ăn được gọi theo ngày. Ví dụ trong ngày hôm nay món A gọi mấy lần, từ bao nhiêu dĩa
	statistic_dish: function (req, res) {
		MongoClient.connect('mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab', function (err, db) {
			var Bill = db.collection("Bill");
			var datenow = new Date().toLocaleDateString();
			let check_date = {};
			if (req.query.type == "day") {
				check_date = {
					$gte: new Date(datenow)
				};
			}
			else if (req.query.type=="week") {
				var curr = new Date; // get current date
				var first = curr.getDate() - curr.getDay(); // First day is the day of the month - the day of the week
				var last = first + 6; // last day is the first day + 6
				var firstday = new Date(curr.setDate(first));
				var lastday = new Date(curr.setDate(last));
				check_date = {
					$gte: firstday,
					$lt: lastday
				}
			}
			else if (req.query.type == "month")
			{
				let date = new Date();
				var firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
				var lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);
				check_date = {
					$gte: firstDay,
					$lt: lastDay
				}
			}
			else if (req.query.type == "custom" && req.query.date) {
				var beginday = new Date(new Date(req.query.date).toLocaleString());
				var endday = new Date(beginday.getTime() + 1000 * 60 * 60 * 24);
				check_date = {
					$gte: beginday,
					$lt: endday,
				}
			}
			
			
			if (req.query.type ) 
			{
				var match = {
					"payment_status": 1,
					"payment_at": check_date
				}
			}
			else {
				var match = {
					"payment_status": 1,
				}
			}
			Bill.aggregate([
				{
					$match: match
				},
				{
					$unwind: "$dishes"
				},
				{
					$group: {
						_id: {
							// day: { $dayOfMonth: "$payment_at" },
							// month: { $month: "$payment_at" },
							// year: { $year: "$payment_at" },
							lishDishID: "$dishes._id",
							namedish: "$dishes.name"
						},
						count: { $sum: 1 },
						total_plate: { $sum: { $multiply: ["$dishes.count", "$table"] } },
					},
				},
				{
					$project: {
						_id: 0,
						count: 1,
						total_plate: 1,
						name: "$_id.namedish",
						// date: {
						// 	$concat: [
						// 		{ $substr: ["$_id.month", 0, 2] }, "/",
						// 		{ $substr: ["$_id.day", 0, 2] }, "/",
						// 		{ $substr: ["$_id.year", 0, 4] }
						// 	]
						// },
					}
				},
				{
					$sort: { total_plate: -1 }
				},
			]).toArray(function (err, data) {
				if (err) console.log(err);
				if (err || !data) res.status(400).send({ message: "Lỗi khi thống kê món ăn", data: "false" });
				else res.status(200).send({ message: "Thống kê món ăn được gọi trong 1 ngày/tháng/năm", data: data });
			})
		})
	},
	// thong ke theo nguoi dung
	statistic_customer: function(req, res) {
		MongoClient.connect('mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab', function (err, db) {
			var Bill = db.collection("Bill");
			var datenow = new Date().toLocaleDateString();
			let check_date = {};
			if (req.query.type == "day") {
				check_date = {
					$gte: new Date(datenow)
				};
			}
			else if (req.query.type=="week") {
				var curr = new Date; // get current date
				var first = curr.getDate() - curr.getDay(); // First day is the day of the month - the day of the week
				var last = first + 6; // last day is the first day + 6
				var firstday = new Date(curr.setDate(first));
				var lastday = new Date(curr.setDate(last));
				check_date = {
					$gte: firstday,
					$lt: lastday
				}
			}
			else if (req.query.type == "month")
			{
				let date = new Date();
				var firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
				var lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);
				check_date = {
					$gte: firstDay,
					$lt: lastDay
				}
			}
			else if (req.query.type == "custom" && req.query.date) {
				var beginday = new Date(new Date(req.query.date).toLocaleString());
				var endday = new Date(beginday.getTime() + 1000 * 60 * 60 * 24);
				check_date = {
					$gte: beginday,
					$lt: endday,
				}
			}
			if (req.query.type ) 
			{
				var match = {
					"payment_at": check_date,
					"payment_status": (req.query.payment_status==1)?1:0
				}
			}
			else {
				var match = {
					"payment_status": (req.query.payment_status==1)?1:0
				}
			}
			Bill.aggregate([
				{
					$match: match
				},
				{
					$group: {
						_id: "$customer",
						count_bill: { $sum: 1 },
						total_money: { $sum: "$total" },
					},
				},
				{
					$sort: { total_money: -1 }
				},
			]).toArray(function (err, data) {
				if (err) console.log(err);
				if (err || !data) res.status(400).send({ message: "Lỗi khi thống kê khách hàng", data: "false" });
				else res.status(200).send({ message: "Thống kê khách hàng trả tiền 1 ngày/tháng/năm", data: data });
			})
		})
	},
	statistic_staff: function(req, res) {
		MongoClient.connect('mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab', function (err, db) {
			var Bill = db.collection("Bill");
			var datenow = new Date().toLocaleDateString();
			let check_date = {};
			if (req.query.type == "day") {
				check_date = {
					$gte: new Date(datenow)
				};
			}
			else if (req.query.type=="week") {
				var curr = new Date; // get current date
				var first = curr.getDate() - curr.getDay(); // First day is the day of the month - the day of the week
				var last = first + 6; // last day is the first day + 6
				var firstday = new Date(curr.setDate(first));
				var lastday = new Date(curr.setDate(last));
				check_date = {
					$gte: firstday,
					$lt: lastday
				}
			}
			else if (req.query.type == "month")
			{
				let date = new Date();
				var firstDay = new Date(date.getFullYear(), date.getMonth(), 1);
				var lastDay = new Date(date.getFullYear(), date.getMonth() + 1, 0);
				check_date = {
					$gte: firstDay,
					$lt: lastDay
				}
			}
			else if (req.query.type == "custom" && req.query.date) {
				var beginday = new Date(new Date(req.query.date).toLocaleString());
				var endday = new Date(beginday.getTime() + 1000 * 60 * 60 * 24);
				check_date = {
					$gte: beginday,
					$lt: endday,
				}
			}
			if (req.query.type ) 
			{
				var match = {
					"payment_at": check_date,
					"payment_status": 1,
					"payment_type": 0
				}
			}
			else {
				var match = {
					"payment_status": 1,
					"payment_type": 0
				}
			}
			Bill.aggregate([
				{
					$match: match
				},
				{
					$group: {
						_id: "$payment_by",
						count_bill: { $sum: 1 },
						total_money: { $sum: "$total" },
					},
				},
				{
					$sort: { total_money: -1 }
				},
			]).toArray(function (err, data) {
				if (err) console.log(err);
				if (err || !data) res.status(400).send({ message: "Lỗi khi thống kê nhân viên", data: "false" });
				else res.status(200).send({ message: "Thống kê số tiền nhân viên đã thanh toán trong 1 ngày/tháng/năm", data: data });
			})
		})
	},
	statistic_dashboard: function(req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			async function (err, db) {
				var User = db.collection("User");
				var Post = db.collection("Posts");
				var Bill = db.collection("Bill");
				var Menu = db.collection("Menu");

				var curr = new Date; // get current date
				var first = curr.getDate() - curr.getDay(); // First day is the day of the month - the day of the week
				var last = first + 6; // last day is the first day + 6
				var firstday = new Date(curr.setDate(first));
				var lastday = new Date(curr.setDate(last));
				// get user moi theo tuan
				let user_new = await User.find({
					create_at: {
						$gte: firstday,
						$lt: lastday
					}
				}, {
					password: 0,
					otp_register: 0,
					otp_register_at: 0,
					update_at: 0
				}).toArray();
				
				// get bai viet moi theo tuan
				let post_new = await Post.find({
					create_at: {
						$gte: firstday,
						$lt: lastday
					}
				}).toArray();
				
				// get hoa don moi
				let invoice_new = await Bill.find(
					{
						create_at: {
							$gte: firstday,
							$lt: lastday
						}
					}
				).toArray();

				// get mon an moi
				let dish_new = await Menu.find(
					{
						create_at: {
							$gte: firstday,
							$lt: lastday
						}
					}
				).toArray();
				res.status(200).send(
					{
						message: "Lấy thông tin mới dashboard",
						data: {
							user_new: {
								length: user_new.length,
								data: user_new
							},
							post_new: {
								length: post_new.length,
								data: post_new,
							},
							invoice_new: {
								length: invoice_new.length,
								data: invoice_new
							},
							dish_new: {
								length: dish_new.length, 
								data: dish_new
							}
						}
					}
				)
			})
	},
	// up hình
	upload_image: function (req, res) {
		if (req.files && req.files.length != 0) {
			let array_image = [];
			for (let index of req.files) {
				array_image.push("http://localhost:3000/open_image?image_name=" + index.filename)
			}
			if (req.body.type)
				res.status(200).send({message: "Upload ảnh thành công", data: array_image, link: array_image[0]}) 
			else 
			res.status(200).send({ message: "Upload ảnh thành công", data: array_image });
		}
		else res.status(400).send({ message: "Không có hình ảnh nào được tải lên thành công", data: "true" })
	},
	add_categories: function(req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Categories = db.collection("Categories");
				if (req.body.name) {
					Categories.findOne({ name: req.body.name},function (err, data) {
						if (!data) {
							if (!req.body.description) req.body.description = "";
							if (!req.body.type) req.body.type = "menu";
							req.body.author = req.body.username;
							req.body.create_at = new Date();
							req.body.update_at = new Date();
							delete req.body.username;
							Categories.insertOne(req.body, function(err, data ) {
								if (err || !data) res.status(400).send({message: "Lỗi khi insert chuyên mục", data: "false"});
								else res.status(200).send({message: "Thêm chuyên mục thành công", data: data.ops[0]});
							})
						}
						else res.status(400).send({message: "Tên categories đã được sử dụng",data: "false"});
					})
				}
				else res.status(400).send({ message: "Tên tên không được rỗng", data: "false" });
			})
	},
	get_categories: function(req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Categories = db.collection("Categories");
				Categories.find({type: "menu"}).toArray(function(err, data) {
					res.status(200).send({message: "Lấy danh sách categories của món ăn", data: data})
				})
			})
	},
	edit_categories: function(req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Categories = db.collection("Categories");
				if (req.body._id == undefined || ObjectId.isValid(req.body._id) == false) res.status(400).send({ message: "ID món ăn không được rỗng", data: "true" });
				else {
					if (!req.body.description) req.body.description = "";
					Categories.findOneAndUpdate({_id: new ObjectId(req.body._id)}, {$set: {
						description: req.body.description, name: req.body.name, update_at: new Date()
					}}, { returnOriginal: false }, function(err, data ) {
						if (err || !data || !data.value) res.status(400).send({message: "Lỗi khi insert chuyên mục", data: "false"});
						else res.status(200).send({message: "Chỉnh sửa chuyên mục thành công", data: data.value});
					})
				}
			})
	},
	del_categories: function(req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Categories = db.collection("Categories");
				if (req.body._id == undefined || ObjectId.isValid(req.body._id) == false) res.status(400).send({ message: "ID món ăn không được rỗng", data: "true" });
				else {
					Categories.remove({_id: new ObjectId(req.body._id)}, function(err, data) {
						if (err || !data ) res.status(400).send({message: "Lỗi khi xóa chuyên mục", data: "false"});
						else res.status(200).send({message: "Xóa chuyên mục món ăn thành công", data: "true"})
					})
				}
			})
	},
	add_post: function(req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Posts = db.collection("Posts");
				if (req.body.title) {
					req.body.link = khongdau(req.body.title, ['chuyen', 'url']);
					if (req.body.link[0] == '-') req.body.link = req.body.link.slice(1, req.body.link.length);
                    if (req.body.link[req.body.link.length - 1] == '-') req.body.link = req.body.link.slice(0, req.body.link.length - 1);
					req.body.link = "http://localhost/client/post/detail/"+req.body.link
					Posts.findOne({ link: req.body.link},function (err, data) {
						if (!data && !err) {
							if (!req.body.content) req.body.content = "";
							if (!req.body.type) req.body.type = "post";
							if (!req.body.feature_image) req.body.feature_image = "http://localhost:3000/open_image?image_name=default.png";
							req.body.author = req.body.username;
							req.body.create_at = new Date();
							req.body.update_at = new Date();
							delete req.body.username;
							Posts.insertOne(req.body, function(err, data ) {
								if (err) res.status(400).send({message: "Lỗi khi insert bài viết", data: "false"});
								else res.status(200).send({message: "Thêm bài viết thành công", data: data.ops[0]});
							})
						}
						else res.status(400).send({message: "Tiêu đề bài viết đã được sử dụng",data: "false"});
					})
				}
				else res.status(400).send({ message: "Trường tiêu đề không được rỗng", data: "false" });
			})
	},
	edit_post: function(req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Posts = db.collection("Posts");
				if (req.body._id) {
					req.body.link = khongdau(req.body.title, ['chuyen', 'url']);
					if (req.body.link[0] == '-') req.body.link = req.body.link.slice(1, req.body.link.length);
                    if (req.body.link[req.body.link.length - 1] == '-') req.body.link = req.body.link.slice(0, req.body.link.length - 1);
					req.body.link = "http://localhost/client/post/detail/"+req.body.link
					Posts.findOne({ link: req.body.link},function (err, data) {
						if (!err && (!data || data._id==req.body._id)) {
							if (!req.body.content) req.body.content = "";
							if (!req.body.feature_image) req.body.feature_image = "http://localhost:3000/open_image?image_name=default.png";
							Posts.findOneAndUpdate({_id: new ObjectId(req.body._id)}, {$set: {
								title: req.body.title, link: req.body.link, feature_image: req.body.feature_image,
								content: req.body.content, update_at: new Date()
							}}, { returnOriginal: false }, function(err, data ) {
								if (err || !data || !data.value) res.status(400).send({message: "Lỗi khi cập nhật bài viết", data: "false"});
								else res.status(200).send({message: "Thêm bài viết thành công", data: data.value});
							})
						}
						else res.status(400).send({message: "Tiêu đề bài viết đã được sử dụng",data: "false"});
					})
				}
				else res.status(400).send({ message: "Trường _id không được rỗng", data: "false" });
			})
	}, 
	get_post: function(req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			function (err, db) {
				var Posts = db.collection("Posts");
				if (req.params.id) {
					if (ObjectId.isValid(req.params.id))
						Posts.findOne({ _id:new ObjectId(req.params.id)},function (err, data) {
							if (!err && data) {
								res.status(200).send({message: "Lấy nội dung bài viết", data: data});
							}
							else res.status(400).send({message: "Không tìm thấy Id bài viết",data: "false"});
						})
					else Posts.findOne({ link: "http://localhost/client/post/detail/" + req.params.id},function (err, data) {
						if (!err && data) {
							res.status(200).send({message: "Lấy nội dung bài viết", data: data});
						}
						else res.status(400).send({message: "Không tìm thấy Id bài viết",data: "false"});
					})
				}
				else res.status(400).send({ message: "Trường _id không được rỗng", data: "false" });
			})
	},
	delete_post: function(req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			async function (err, db) {
				var Posts = db.collection("Posts");
				if (ObjectId.isValid(req.params.id) == false) res.status(400).send({ message: "ID bài viết không hợp lệ", data: "false" });
				else {
					Posts.remove({_id: new ObjectId(req.params.id)}, function(err, data) {
						if (err || !data ) res.status(400).send({message: "Lỗi khi xóa bài viết", data: "false"});
						else res.status(200).send({message: "Xóa chuyên mục món ăn thành công", data: "true"})
					})
				}
			})
	},
	get_list_post: function(req, res) {
		MongoClient.connect(
			'mongodb://partybooking:ktxkhua@localhost:27017/Android_Lab',
			async function (err, db) {
				var Posts = db.collection("Posts");
				if (req.query.author && req.query.author.length!=0) {
					Posts.find({author: req.query.author}).toArray(function (err, data) {
						if (!err || data) {
							for (let index of data) {
								if (index.content) {
									var summary = cheerio.load(index.content);
									index.summary = summary.text();
									index.summary = index.summary.replace(/\s\s+/g, ' ');
									index.summary = index.summary.slice(0, index.summary.indexOf(' ', 250));
									delete index.content;
								}
							}
							res.status(200).send({message: "Lấy danh sách bài viết của tác giả " + req.query.author, data: data});
						}
						else res.status(400).send({message: "Không có bài viết của tác giả " + req.query.author,data: "false"});
					})
				} 
				else  {
					let total_page = (await Posts.find().toArray()).length;
					total_page = Math.ceil(total_page / 10);
					if (!req.query.page || req.query.page < 1) req.query.page =1;
					Posts.find({}).limit(10).skip(10 * (req.query.page - 1)).toArray(function (err, data) {
						if (!err || data) {
							for (let index of data) {
								if (index.content) {
									var summary = cheerio.load(index.content);
									index.summary = summary.text();
									index.summary = index.summary.replace(/\s\s+/g, ' ');
									index.summary = index.summary.slice(0, index.summary.indexOf(' ', 250));
									delete index.content;
								}
							}
							res.status(200).send({message: "Lấy danh sách bài viết", data: {
								total_page: total_page,
								start: 10 * (req.query.page -1),
								end: (10 * req.query.page ) -1 ,
								value : data
							}});
						}
						else res.status(400).send({message: "Không có bài viết",data: "false"});
					})
				}
			})
	},
	get_status_cpu: async (req, res) => {
		var cpu = osu.cpu
		let usage =await cpu.usage();
		let free =await cpu.free();
		let loadavg= await cpu.loadavg();
		let average= cpu.average()
		let count = cpu.count()

		var drive = osu.drive
		let info = await drive.info()
		

		var mem = osu.mem
		let mem_info = await mem.info()
		
		
		return res.status(200).send({
			cpu: {
				usage,
				free,
				average,
				count
			},
			drive: {
				info,
			},
			memory:  mem_info,
			
			
		})
	}

}
