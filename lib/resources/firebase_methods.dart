import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video_chatting_app/constants/string.dart';
import 'package:video_chatting_app/models/message.dart';
import 'file:///E:/IdeaProjects/video_chatting_app/lib/utils/utilities.dart';
import 'package:video_chatting_app/models/user.dart';
import 'package:video_chatting_app/provider/image_upload_provider.dart';

class FirebaseMethods {

  User user = User();
  StorageReference _storageReference;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final Firestore firestore = Firestore.instance;

  static final Firestore _firestore = Firestore.instance;


  static final CollectionReference _userCollection =
            _firestore.collection(user_collection);

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
    await _signInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _signInAuthentication.idToken,
        accessToken: _signInAuthentication.accessToken);

    AuthResult result = await _auth.signInWithCredential(credential);
//    FirebaseUser user = result.user;
//    return user;
    return result.user;
  }
  Future<User> getUserDetails() async {
    FirebaseUser currentUser = await getCurrentUser();

    DocumentSnapshot documentSnapshot =
    await _userCollection.document(currentUser.uid).get();

    return User.fromMap(documentSnapshot.data);
  }


  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await firestore.collection(user_collection)
        .where(Email, isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    String username = Utils.getUsername(currentUser.email);
    user = User(
        uid: currentUser.uid,
        email: currentUser.email,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoUrl,
        username: username,
    );

    firestore.collection(user_collection).document(currentUser.uid).setData(
        user.toMap(user));
  }
  
  Future<void> signOut() async{
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
}

Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async{
    List<User> userList = List<User>();

    QuerySnapshot querySnapshot =
    await firestore.collection(user_collection).getDocuments();
    for(var i = 0 ; i < querySnapshot.documents.length; i++){
      if (querySnapshot.documents[i].documentID !=  currentUser.uid){
        userList.add(User.fromMap(querySnapshot.documents[i].data));
      }
    }
    return userList;
  }

  Future<void> addMessageToDb(  Message message, User sender , User receiver)
  async {
    var map = message.toMap();
    await firestore
    .collection(Messages_collection)
    .document(message.senderId)
    .collection(message.receiverId)
    .add(map);

return await firestore.collection(Messages_collection)
    .document(  message.receiverId
).collection(message.senderId)
.add(map);
}

Future<String> uploadImageToDb(File image) async{
  try{
    _storageReference = FirebaseStorage.instance
        .ref()
        .child('${DateTime.now().millisecondsSinceEpoch}');

    StorageUploadTask _storageUploadTask = _storageReference.putFile(image);
    var url = await(await _storageUploadTask.onComplete).ref.getDownloadURL();
    return url;

  }catch(e){
    print(e);
    return null;

  }

}

void setImageMsg(String url ,String receiverId, String senderId) async{
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
    await firestore
        .collection(Messages_collection)
        .document(_message.senderId)
        .collection(_message.receiverId)
        .add(map);

      await firestore.collection(Messages_collection)
        .document(_message.receiverId)
    .collection(_message.senderId)
        .add(map);



}
void uploadImage(File image ,String receiverId, String senderId,ImageUploadProvider imageUploadProvider) async{
    imageUploadProvider.setToLoading();
    String url = await uploadImageToDb(image);
    imageUploadProvider.setToIdle();
    setImageMsg(url, receiverId,senderId);
}


}