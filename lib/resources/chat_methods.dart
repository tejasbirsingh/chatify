import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_chatting_app/constants/string.dart';
import 'package:video_chatting_app/models/contact.dart';
import 'package:video_chatting_app/models/message.dart';
import 'package:video_chatting_app/models/user.dart';

class ChatMethods {
  static final Firestore _firestore = Firestore.instance;
  final CollectionReference _messageCollection =
      _firestore.collection(Messages_collection);
  final CollectionReference _userCollection =
      _firestore.collection(user_collection);

  Future<void> addMessageToDb(
      Message message, User sender, User receiver) async {
    var map = message.toMap();
    await _messageCollection
        .document(message.senderId)
        .collection(message.receiverId)
        .add(map);

    addToContacts(senderId: message.senderId, receiverId: message.receiverId);

    return await _messageCollection
        .document(message.receiverId)
        .collection(message.senderId)
        .add(map);
  }

  DocumentReference getContactDocument({String of, String forContact}) =>
      _userCollection
          .document(of)
          .collection(Contacts_reference)
          .document(forContact);

  addToContacts({String senderId, String receiverId}) async {
    Timestamp currentTime = Timestamp.now();
    await addToSenderContact(senderId, receiverId, currentTime);
    await addToReceiverContact(senderId, receiverId, currentTime);
  }

  Future<void> addToSenderContact(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot senderSnapshot =
        await getContactDocument(of: senderId, forContact: receiverId).get();
    if (!senderSnapshot.exists) {
      Contact recieverContact = Contact(
        uid: receiverId,
        addedOn: currentTime,
      );
      var receiverMap = recieverContact.toMap(recieverContact);
      await getContactDocument(of: senderId, forContact: receiverId)
          .setData(receiverMap);
    }
  }

  Future<void> addToReceiverContact(
    String senderId,
    String receiverId,
    currentTime,
  ) async {
    DocumentSnapshot receiverSnapshot =
        await getContactDocument(of: receiverId, forContact: senderId).get();
    if (!receiverSnapshot.exists) {
      Contact senderContact = Contact(
        uid: senderId,
        addedOn: currentTime,
      );
      var senderMap = senderContact.toMap(senderContact);
      await getContactDocument(of: receiverId, forContact: senderId)
          .setData(senderMap);
    }
  }

  Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async {
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
        await _firestore.collection(user_collection).getDocuments();
    for (var i = 0; i < querySnapshot.documents.length; i++) {
      if (querySnapshot.documents[i].documentID != currentUser.uid) {
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }

  void setImageMsg(String url, String receiverId, String senderId) async {
    Message _message;
    _message = Message.imageMessage(
      message: "IMAGE",
      receiverId: receiverId,
      senderId: senderId,
      photoUrl: url,
      timestamp: Timestamp.now(),
      type: 'image',
    );
    var map = _message.toImageMap();
    await _messageCollection
        .document(_message.senderId)
        .collection(_message.receiverId)
        .add(map);

    await _messageCollection
        .document(_message.receiverId)
        .collection(_message.senderId)
        .add(map);
  }

  Stream<QuerySnapshot> fetchContacts({String userId}) => _userCollection
      .document(userId)
      .collection(Contacts_reference)
      .snapshots();
  
Stream<QuerySnapshot> fetchFriends({String userId}) =>_userCollection
    .document(userId)
    .collection(friends_reference)
    .snapshots();

  Stream<QuerySnapshot> fetchLastMessageBetween({
    @required String senderId,
    @required String receiverId,
  }) =>
      _messageCollection
          .document(senderId)
          .collection(receiverId)
          .orderBy("timestamp")
          .snapshots();

  Future<void> sendRequest(
      {User currentUser, User requestReceiver}) async {
    var followingMap = Map<String, String>();
    followingMap['uid'] = requestReceiver.uid;
    followingMap['name'] = requestReceiver.name;
    await _firestore
        .collection(user_collection)
        .document(currentUser.uid)
        .collection("friends")
        .document(requestReceiver.uid)
        .setData(followingMap);

    var followersMap = Map<String, String>();
    followersMap['uid'] = currentUser.uid;
    followersMap['name'] = currentUser.name;

    return _firestore
        .collection(user_collection)
        .document(requestReceiver.uid)
        .collection(friends_reference)
        .document(currentUser.uid)
        .setData(followersMap);
  }
  Future<void> removeFriend(
      {User user, User friend}) async {
    await _firestore
        .collection(user_collection)
        .document(user.uid)
        .collection(friends_reference)
        .document(friend.uid)
        .delete();

    return _firestore
        .collection(user_collection)
        .document(friend.uid)
        .collection(friends_reference)
        .document(user.uid)
        .delete();
  }



}
