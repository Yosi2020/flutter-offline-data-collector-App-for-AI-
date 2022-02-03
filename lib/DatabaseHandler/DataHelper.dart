import 'package:eyu_data_collection/model/dataInfo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

final String tableData = 'Data';
final String columnId = 'id';
final String columnimage = 'image';
final String columnLabelName = 'Label_Name';
final String columnEmail = 'email';
final String columnlat = 'Latitude';
final String columnLong = 'Longitude';
final String columnDate = 'dateTime';

class DataHelper {
  static Database _database;
  static DataHelper _dataHelper;

  DataHelper._createInstance();
  factory DataHelper() {
    if (_dataHelper == null) {
      _dataHelper = DataHelper._createInstance();
    }
    return _dataHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    String dir = await getDatabasesPath();
    String path = join(dir, "eyu.db");

    var database = await openDatabase(
      path,
      version: 10,
      onCreate: (db, version) async {
        await db.execute('''
          create table $tableData ( 
          $columnId integer primary key autoincrement, 
          $columnimage text not null,
          $columnLabelName text not null,
          $columnEmail text,
          $columnlat integer not null,
          $columnLong integer not null,
          $columnDate text not null)
        ''');
      },
    );
    return database;
  }

  Future<int> insertData(dataInfo alarmInfo) async {
    print("i am here");
    var db = await this.database;
    print("i amm eu");
    var result = await db.insert(tableData, alarmInfo.toMap());
    print('result : $result');
  }

  Future<int> delete(String id) async {
    var db = await this.database;
    return await db.delete(tableData, where: '$columnEmail = ?', whereArgs: [id]);
  }

  Future<List<dataInfo>> getData() async {
    List<dataInfo> bankList = [];

    var db = await this.database;
    var result = await db.query(tableData);
    result.forEach((element) {
      var DataInfo = dataInfo.fromMap(element);
      bankList.add(DataInfo);
    });

    return bankList;
  }

  Future<int> updateData(dataInfo DataInfo) async {
    var db = await this.database;
    var result = await db.update(tableData, DataInfo.toMap(), where: '$columnId = ?', whereArgs: [DataInfo.id]);
    print('result : $result');
  }

}