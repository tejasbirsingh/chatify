import 'package:flutter/material.dart';
import 'file:///E:/IdeaProjects/video_chatting_app/lib/utils/utilities.dart';
import 'package:video_chatting_app/resources/firebase_repository.dart';
import 'package:video_chatting_app/widgets/appBar.dart';
import 'package:video_chatting_app/widgets/custom_tile.dart';

class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}
final FirebaseRepository _repository = FirebaseRepository();

class _ChatListScreenState extends State<ChatListScreen> {
  String currentUserId;
  String initials;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _repository.getCurrentUser().then((user){
      setState(() {
        currentUserId = user.uid;
        initials = Utils.getInitials(user.displayName);
      });
    });
  }

  CustomAppBar customAppBar(BuildContext context){
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(Icons.notifications,
        color: Colors.white,),
        onPressed: () {},
      ),
      title: UserCircle(initials),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Navigator.pushNamed(context, "/search_page");
          },
        ),
        IconButton(
          icon: Icon(Icons.menu),
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(currentUserId),
    );
  }
}
class ChatListContainer extends StatefulWidget {
  final String currentUserId;

   ChatListContainer(this.currentUserId);

  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
return ListView.builder(padding: EdgeInsets.all(10),
itemCount: 2,
    itemBuilder: (context , index){

  return CustomTile(
    mini: false,
    onTap: () {},
    title: Text(
      'TBS',
      style: TextStyle(
        color: Colors.white , fontFamily: "Arial",fontSize: 19.0
      ),
    ),
    subtitle: Text("Hello",
    style: TextStyle(
      color: Colors.grey,
      fontSize: 14
    ),),
    leading: Container(
      constraints: BoxConstraints(maxHeight: 60.0 , maxWidth: 60.0),
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            maxRadius: 30.0,
            backgroundColor: Colors.grey,
          //  backgroundImage: NetworkImage(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 30.0,
              width: 30.0,
              decoration: BoxDecoration(
                shape:  BoxShape.circle,
                color: Colors.blueAccent,
                border: Border.all(
                  color: Colors.black,
                  width: 2
                )
              ),
            ),
          )
        ],
      ),
    ),
  );




    });  }
}




class UserCircle extends StatelessWidget {
  final String text;
  UserCircle(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: 40.0,
      decoration: BoxDecoration(
        borderRadius:  BorderRadius.circular(60.0),
        color: Colors.white
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
                fontSize: 13,
              ),


            ),
          ),

          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border : Border.all(
                  color:Colors.black,
                  width: 2
                ),
                color: Colors.green
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NewChatButton extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple,Colors.purple.shade900],
        ),
        borderRadius: BorderRadius.circular(50.0),

      ),
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 25.0,
      ),
      padding: EdgeInsets.all(30.0),
    );
  }
}
