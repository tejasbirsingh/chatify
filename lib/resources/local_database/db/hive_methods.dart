



import 'dart:io';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_chatting_app/models/log.dart';
import 'package:video_chatting_app/resources/local_database/interface/log_interface.dart';

class HiveMethods implements LogInterface{

  String hive_box = "Call_Logs";
  @override
  init() async{
    Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }


  @override
  addLogs(Log log) async{
  var box = await Hive.openBox(hive_box);
  var logMap = log.toMap(log);
  int idOfInput = await box.add(logMap);
  box.put("custom_key", logMap);
  close();
  return idOfInput;

  }

  updateLogs(int i , Log newLog) async{
    var box = await Hive.openBox(hive_box);

    var newLogMap = newLog.toMap(newLog);

    box.putAt(i, newLogMap);
  }

  @override
  close() => Hive.close();

  @override
  deleteLogs(int logId) async {
  var box = await Hive.openBox(hive_box);

  await box.delete(logId);

  }


  @override
  Future<List<Log>> getLogs() async{
    var box = await Hive.openBox(hive_box);

    List<Log> logList = [];
    for(int i =0; i <box.length;i++){
      var logMap = box.getAt(i);
      logList.add(Log.fromMap(logMap));
    }
    return logList;
  }


  
}