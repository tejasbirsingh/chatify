import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ChatListScreen.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PageController pageController;
  int _page = 0;
  var _label = 20.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }
  void navigationTapped(int page){
    pageController.jumpToPage(page);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: PageView(
       children: <Widget>[
       Container(child: ChatListScreen()),
         Center(child: Text('Call Logs'),),
         Center(child: Text('Contact Screen'),)
       ],
       controller: pageController,
       onPageChanged: onPageChanged,
//       physics: NeverScrollableScrollPhysics(),
     ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          child: CupertinoTabBar(
            backgroundColor: Colors.grey,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.chat,
                color: (_page==0) ? Colors.lightBlueAccent : Colors.white,),
                title: Text('Chat',
                style: TextStyle(
                  fontSize: _label,
                  color: (_page ==0) ?
                      Colors.blueAccent :
                      Colors.white
                ),)

              ),
              BottomNavigationBarItem(
                title: Text('Contacts',
                  style: TextStyle(
                      fontSize: _label,
                      color: (_page ==0) ?
                      Colors.blueAccent :
                      Colors.white
                  ),),
                  icon: Icon(Icons.chat,
                    color: (_page==1) ? Colors.lightBlueAccent : Colors.white,)
              ),
              BottomNavigationBarItem(
                title: Text('call',
                  style: TextStyle(
                      fontSize: _label,
                      color: (_page ==0) ?
                      Colors.blueAccent :
                      Colors.white
                  ),),
                  icon: Icon(Icons.chat,
                    color: (_page==2) ? Colors.lightBlueAccent : Colors.white,)
              )
            ],
            onTap: navigationTapped,
            currentIndex: _page,
          ),
        ),
      ),
    );
  }
}
