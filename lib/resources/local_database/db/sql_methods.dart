import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:video_chatting_app/models/log.dart';
import 'package:video_chatting_app/resources/local_database/interface/log_interface.dart';

class SqliteMethods implements LogInterface {
  Database _db;
  String databaseName = "LogDB";
  String tableName = "call_logs";
  String id = "log_id";
  String callerName = "caller_name";
  String callerPic = "caller_pic";
  String receiverName = "receiver_name";
  String receiverPic = "receiver_pic";
  String callStatus = "call_status";
  String timestamp = "timestamp";

  Future<Database> get db async{
    if (_db!=null){
      return _db;
    }
    _db  = await init();
    return _db;
  }
  @override
  init() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path,databaseName);
  var db = await openDatabase(path, version: 1, onCreate: _onCreate);
  return db;
  }

    _onCreate(Database db , int version) async{
    String createTableQuery =
        "CREATE TABLE $tableName ($id INTEGER PRIMARY KEY, $callerName TEXT, $callerPic TEXT, $receiverName TEXT, $receiverPic TEXT, $callStatus TEXT, $timestamp TEXT)";
    await db.execute(createTableQuery);
    print("Created table");
    }
  @override
  addLogs(Log log) async{
    var dbClient = await db;
    await dbClient.insert(tableName, log.toMap(log));

  }

  updateLogs(Log log) async{
    var dbClient = await db;

    await dbClient.update(tableName,
    log.toMap(log),
    whereArgs: [log.logId],
    where: '$id = ?');
  }

  @override
  deleteLogs(int logId) async{
    var dbClient = await db;
    return await dbClient.delete(tableName,where:'$id = ?', whereArgs: [logId]);

  }

  @override
  Future<List<Log>> getLogs() async{
    try{
      var dbClient = await db;
    //  List<Map> maps =await dbClient.rawQuery("SELECT * FROM $tableName");
      List<Map> maps = await dbClient.query(
        tableName,
        columns: [
          id ,
          callerName,
          receiverName,
          receiverPic,
          callStatus,
          timestamp,
        ],
      );

      List<Log> logList = [];

      if (maps.isNotEmpty){
        for (Map map in maps){
          logList.add(Log.fromMap(map));
        }
      }

      return logList;
    }catch(e){
      print(e);
      return null;
    }

  }

  @override
  close() async{
    var dbClient = await db;
    dbClient.close();

  }
}
