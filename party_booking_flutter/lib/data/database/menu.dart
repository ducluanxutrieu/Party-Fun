import 'package:sqflite/sqflite.dart';

class DatabaseMenu{

  void setupDatabase() async {
//    var databasesPath = await getDatabasesPath();
//    String path = join(databasesPath, 'party_booking_db.db');
//    var db = await openDatabase('party_booking_db.db');

    // open the database
    Database database = await openDatabase('party_booking_db.db', version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE IF NOT EXISTS Menu(_id VARCHAR NULL, name VARCHAR NULL, description VARCHAR NULL, price INT NULL, type VARCHAR NULL, discount INT NULL, image JSON NULL, updateAt VARCHAR NULL, createAt VARCHAR NULL, usercreate VARCHAR NULL, rate.average INT NULL, rate.lishRate JSON NULL, rate.totalpeople INT NULL)');
        });
  }

  /*
  String id;
  String name;
  String description;
  int price;
  String type;
  int discount;
  List<String> image;
  String updateAt;
  String createAt;
  RateModel rate;
   */
}