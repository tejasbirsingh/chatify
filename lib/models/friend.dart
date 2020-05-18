import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';

class Friend{
  String uid;
  String  name;

  Friend({
    this.uid,
    this.name
  });
  Map toMap(Friend contact){
    var data = Map<String, dynamic>();
    data['uid'] = contact.uid;
    data['name'] = contact.name;
    return data;
  }

  Friend.fromMap(Map<String, dynamic> mapData){
    this.uid = mapData['uid'];
    this.name = mapData['name'];

  }

}