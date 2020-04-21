import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_chatting_app/constants/string.dart';
import 'package:video_chatting_app/enum/view_state.dart';
import 'package:video_chatting_app/models/message.dart';
import 'package:video_chatting_app/models/user.dart';
import 'package:video_chatting_app/provider/image_upload_provider.dart';
import 'package:video_chatting_app/resources/auth_methods.dart';
import 'package:video_chatting_app/resources/chat_methods.dart';
import 'package:video_chatting_app/resources/firebase_repository.dart';
import 'package:video_chatting_app/resources/storage_methods.dart';
import 'package:video_chatting_app/utils/call_utilities.dart';
import 'package:video_chatting_app/utils/permissions.dart';
import 'package:video_chatting_app/utils/utilities.dart';
import 'package:video_chatting_app/widgets/appBar.dart';
import 'package:video_chatting_app/widgets/cached_image.dart';
import 'package:video_chatting_app/widgets/custom_tile.dart';

class ChatPage extends StatefulWidget {
  final User receiver;

  const ChatPage({Key key, this.receiver}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ImageUploadProvider _imageUploadProvider;
final AuthMethods _authMethods = AuthMethods();
final ChatMethods _chatMethods = ChatMethods();
final StorageMethods _storageMethods =StorageMethods();
FocusNode textFieldFocus = FocusNode();

  TextEditingController textEditingController = TextEditingController();
  ScrollController _listScrollController = ScrollController();
  bool emojiOn = false;
  bool onTap = false;
  User sender;
  String _currentUserId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authMethods.getCurrentUser().then((user) {
      _currentUserId = user.uid;
      setState(() {
        sender = User(
            uid: user.uid, name: user.displayName, profilePhoto: user.photoUrl);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(context),
        body: Column(
          children: <Widget>[
            Flexible(
              child: messageList(),
            ),
            _imageUploadProvider.getViewState == ViewState.LOADING
                ? Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 15),
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            chatControls(),
            emojiOn
                ? Container(
                    child: emojiContainer(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: Colors.grey,
      indicatorColor: Colors.blueAccent,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          onTap = true;
        });
        textEditingController.text = textEditingController.text + emoji.emoji;
      },
      recommendKeywords: ['face', 'party', 'sad', 'happy'],
      numRecommended: 30,
    );
  }

  Widget messageList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection(Messages_collection)
          .document(_currentUserId)
          .collection(widget.receiver.uid)
          .orderBy(TimeStampField, descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

//        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
//          _listScrollController.animateTo(
//          _listScrollController.position.minScrollExtent,
//              duration: Duration(milliseconds: 200),
//              curve: Curves.easeInOut);
//        });
        return ListView.builder(
          controller: _listScrollController,
          reverse: true,
          padding: EdgeInsets.all(10),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return chatMessageItem(snapshot.data.documents[index]);
          },
        );
      },
    );
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hiddenKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      emojiOn = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      emojiOn = true;
    });
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _message = Message.fromMap(snapshot.data);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(
        alignment: _message.senderId == _currentUserId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: _message.senderId == _currentUserId
            ? senderLayout(_message)
            : receiverLayout(_message),
      ),
    );
  }

  sendMessage() {
    var text = textEditingController.text;
    Message _message = Message(
        receiverId: widget.receiver.uid,
        senderId: sender.uid,
        message: text,
        timestamp: Timestamp.now(),
        type: 'text');
    setState(() {
      onTap = false;
      textEditingController.text = "";
    });
    _chatMethods.addMessageToDb(_message, sender, widget.receiver);
  }

  Widget senderLayout(Message message) {
    Radius messageRadius = Radius.circular(10);
    return Container(
      margin: EdgeInsets.only(top: 12),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
      decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.only(
              topLeft: messageRadius,
              topRight: messageRadius,
              bottomLeft: messageRadius)),
      padding: EdgeInsets.all(10),
      child: getMessage(message),
    );
  }

  getMessage(Message message) {
    return message.type != Is_Image
        ? Text(
            message != null ? message.message : '',
            style: TextStyle(color: Colors.white, fontSize: 15.0),
          )
        : message.photoUrl != null
            ? CachedImage(
                message.photoUrl,
                height: 250.0,
                width: 250.0,
              )
            : Text('Sending');
  }

  Widget receiverLayout(Message message) {
    Radius messageRadius = Radius.circular(10);
    return Container(
        margin: EdgeInsets.only(top: 12),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
        decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.only(
                bottomRight: messageRadius,
                topRight: messageRadius,
                bottomLeft: messageRadius)),
        padding: EdgeInsets.all(10),
        child: getMessage(message));
  }

  customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: false,
      title: Text(
        widget.receiver.name,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.video_call,
          ),
          onPressed: () async =>
              await Permissions.cameraAndMicrophonePermissionsGranted()
                  ? CallUtils.dial(
                      from: sender, to: widget.receiver, context: context)
                  : {},
        ),
        IconButton(
          icon: Icon(Icons.call),
          onPressed: () {},
        )
      ],
    );
  }

  pickImage(@required ImageSource source) async {
    File selectedImage = await Utils.pickImage(source: source);
    _storageMethods.uploadImage(
        image: selectedImage,
        receiverId: widget.receiver.uid,
        senderId: _currentUserId,
        imageUploadProvider: _imageUploadProvider);
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        onTap = val;
      });
    }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          builder: (context) {
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Content and tools",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ModalTile(
                        title: 'Media',
                        subtitle: 'Photos and videos',
                        icon: Icons.image,
                        onTap: () => pickImage(ImageSource.gallery),
                      ),
                      ModalTile(
                        title: 'File',
                        subtitle: 'Send Files',
                        icon: Icons.image,
                      ),
                      ModalTile(
                        title: 'Contact',
                        subtitle: 'Share contacts',
                        icon: Icons.image,
                      ),
                      ModalTile(
                        title: 'Location',
                        subtitle: 'Share my location',
                        icon: Icons.image,
                      )
                    ],
                  ),
                )
              ],
            );
          });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => addMediaModal(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.redAccent ,Colors.red],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add,
              color:Colors.white),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: TextField(
                    focusNode: textFieldFocus,
                    onTap: () => hideEmojiContainer(),
                    controller: textEditingController,
                    style: TextStyle(color: Colors.white),
                    onChanged: (val) {
                      (val.length > 0 && val.trim() != "")
                          ? setWritingTo(true)
                          : setWritingTo(false);
                    },
                    decoration: InputDecoration(

                      hintText: "Type a message",
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      contentPadding:
                          EdgeInsets.only(left: 50.0,right: 20.0),
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(Icons.face),
                    onPressed: () {
                      if (!emojiOn) {
                        hiddenKeyboard();
                        showEmojiContainer();
                      } else {
                        showKeyboard();
                        hideEmojiContainer();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
          onTap
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.record_voice_over),
                ),
          onTap
              ? Container()
              : GestureDetector(
                  onTap: () => pickImage(ImageSource.camera),
                  child: Icon(Icons.camera_alt)),
          onTap
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [
                        Colors.redAccent,
                        Colors.red
                      ])),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => sendMessage(),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function onTap;

  const ModalTile(
      {@required this.title,
      @required this.subtitle,
      @required this.icon,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        onTap: onTap,
        leading: Container(
          margin: EdgeInsets.only(right: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.green),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Colors.grey,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
