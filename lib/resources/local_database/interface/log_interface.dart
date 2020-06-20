import 'package:video_chatting_app/models/log.dart';
abstract class LogInterface{

  init();
  addLogs(Log log);

  Future<List<Log>> getLogs();

  deleteLogs(int logId);
  close();

}