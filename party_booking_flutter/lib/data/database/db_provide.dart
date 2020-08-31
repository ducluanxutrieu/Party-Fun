import 'dart:io';

import 'package:party_booking/data/network/model/list_dishes_response_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = "${documentsDirectory.path}/PartyBookingDB.db";
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE ListDishes (id TEXT PRIMARY KEY,name TEXT,description TEXT,price INTEGER,discount INTEGER,currency TEXT,feature_image TEXT, price_new INTEGER)");
      await db.execute(
          "CREATE TABLE ListCategory (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, dish_id TEXT, category TEXT)");
      await db.execute(
          "CREATE TABLE ListImages (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, dish_id TEXT, image TEXT)");
    });
  }

  newDish(DishModel model) async {
    final db = await database;
    var res = await db.rawInsert(
        "INSERT Into ListDishes (id, name, description, price, discount, currency, feature_image, price_new)"
        " VALUES ('${model.id}', '${model.name}','${model.description}',${model.price},${model.discount},'${model.currency}','${model.featureImage}',${model.priceNew})");

    //insert list category
    model.categories.forEach((category) async {
      await db.rawInsert(
          "INSERT Into ListCategory (dish_id, category) VALUES ('${model.id}', '$category')");
    });

    //insert list image
    model.image.forEach((image) async {
      await db.rawInsert(
          "INSERT Into ListImages (dish_id, image) VALUES ('${model.id}', '$image')");
    });
    return res;
  }

/*  newDishBiggestId(DishModel model) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM ListDishes");
    int id = table.first["id"];
    var categories = List<String>.from(model.categories.map((x) => x));
    var images = List<String>.from(model.image.map((x) => x));
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into ListDishes (name,description,price,categories,discount,image,currency)"
        " VALUES (?,?,?,?,?,?,?,?)",
        [model.name, model.description, model.price, categories, model.discount, images, model.currency]);
    return raw;
  }*/

//  insertClDish(Dish newDish) async {
//    final db = await database;
//    var res = await db.insert("ListDishes", newListDishes.toMap());
//    return res;
//  }

  Future<DishModel> getDish(String id) async {
    final db = await database;
    var res = await db.query("ListDishes", where: "id = ?", whereArgs: [id]);
    DishModel dishModel;
    if(res.isNotEmpty){}
    dishModel = DishModel.fromJsonDB(res.first);
    if(dishModel != null){
      List<ImageDb> images = await getListImageByDishId(dishModel.id, db);
      images.forEach((imageModel) {
        dishModel.image.add(imageModel.image);
      });
    }
    return dishModel;
  }

  Future<List<DishModel>> getAllDishes() async {
    final db = await database;
    var res = await db.query("ListDishes");
    List<DishModel> listDishes = res.isEmpty
        ? List<DishModel>()
        : res.map((c) => DishModel.fromJsonDB(c)).toList();

    for (int index = 0; index < listDishes.length; index++) {
      var resCategories = await db.query("ListCategory",
          where: "dish_id = ? ", whereArgs: [listDishes[index].id]);
      List<CategoryDb> categories =
          resCategories.map((c) => CategoryDb.fromJson(c)).toList();

      categories.forEach((category) {
        listDishes[index].categories.add(category.category);
      });

      List<ImageDb> images = await getListImageByDishId(listDishes[index].id, db);
      images.forEach((imageModel) {
        listDishes[index].image.add(imageModel.image);
      });
    }

    return listDishes;
  }

    Future<List<DishModel>> searchAllDishes(String search) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM ListDishes WHERE name LIKE '%$search%'");
    List<DishModel> listDishes = res.isEmpty
        ? List<DishModel>()
        : res.map((c) => DishModel.fromJsonDB(c)).toList();

    for (int index = 0; index < listDishes.length; index++) {
      var resCategories = await db.query("ListCategory",
          where: "dish_id = ? ", whereArgs: [listDishes[index].id]);
      List<CategoryDb> categories =
          resCategories.map((c) => CategoryDb.fromJson(c)).toList();

      categories.forEach((category) {
        listDishes[index].categories.add(category.category);
      });

      List<ImageDb> images = await getListImageByDishId(listDishes[index].id, db);
      images.forEach((imageModel) {
        listDishes[index].image.add(imageModel.image);
      });
    }

    return listDishes;
  }

  Future<List<ImageDb>> getListImageByDishId(
    String dishID, Database db,
  ) async {
    var resImages = await db
        .query("ListImages", where: "dish_id = ? ", whereArgs: [dishID]);
    return resImages.map((c) => ImageDb.fromJson(c)).toList();
  }

/*  getBlockedListDishes() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM ListDishes WHERE blocked=1");
    List<DishModel> list =
        res.isNotEmpty ? res.toList().map((c) => DishModel.fromJson(c)) : null;
    return list;
  }*/

  updateDish(DishModel model) async {
    final db = await database;
    var res = await db.update("ListDishes", model.toJson(),
        where: "id = ?", whereArgs: [model.id]);
    return res;
  }

  /*blockOrUnblock(ListDishes listDishes, bool isBlock) async {
    final db = await database;
    ListDishes blocked = ListDishes(
        id: listDishes.id,
        firstName: listDishes.firstName,
        lastName: listDishes.lastName,
        blocked: isBlock);
    var res = await db.update("ListDishes", blocked.toMap(),
        where: "id = ?", whereArgs: [listDishes.id]);
    return res;
  }*/

  deleteListDishes(int id) async {
    final db = await database;
    db.delete("ListDishes", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete from ListDishes");
    db.rawDelete("Delete from ListCategory");
    db.rawDelete("Delete from ListImages");
  }
}
