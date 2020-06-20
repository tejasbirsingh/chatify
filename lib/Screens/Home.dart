import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:video_chatting_app/Screens/call_pickup/pickup_layout.dart';
import 'package:video_chatting_app/Screens/logs/widgets/log_screen.dart';
import 'package:video_chatting_app/enum/user_state.dart';
import 'package:video_chatting_app/provider/user_provider.dart';
import 'package:video_chatting_app/resources/auth_methods.dart';

import 'file:///E:/IdeaProjects/video_chatting_app/lib/Screens/ContactsScreen/contactsPage.dart';

import 'ChatScreen/widgets/ChatListScreen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  PageController pageController;
  int _page = 0;

  var _label = 20.0;

  UserProvider userProvider;
  final AuthMethods _authMethods = AuthMethods();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();
      _authMethods.setUserState(
          userId: userProvider.getUser.uid, userState: UserState.Online);
    });
    pageController = PageController();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : "";
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: SafeArea(
        child: Scaffold(
          body: PageView(
            children: <Widget>[
              Container(child: ChatListScreen()),

              Container(
                child: contactsPage(),
              ),
              Center(
                child: LogScreen(),
              )
            ],
            controller: pageController,
            onPageChanged: onPageChanged,
//       physics: NeverScrollableScrollPhysics(),
          ),
          bottomNavigationBar: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0.0),
              child: CupertinoTabBar(
                backgroundColor: Theme.of(context).backgroundColor,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.chat,
                        color: (_page == 0)
                            ? Theme.of(context).accentColor
                            : Theme.of(context).textSelectionColor,
                      ),
                      title: Text(
                        'Chat',
                        style: TextStyle(
                            fontSize: _label,
                            color: (_page == 0)
                                ? Theme.of(context).accentColor
                                : Theme.of(context).textSelectionColor),
                      )),
                  BottomNavigationBarItem(
                      title: Text(
                        'Contacts',
                        style: TextStyle(
                            fontSize: _label,
                            color: (_page == 1)
                                ? Theme.of(context).accentColor
                                : Theme.of(context).textSelectionColor),
                      ),
                      icon: Icon(
                        Icons.contacts,
                        color: (_page == 1)
                            ?Theme.of(context).accentColor
                            : Theme.of(context).textSelectionColor,
                      )),
                  BottomNavigationBarItem(

                      title: Text(
                        'call',
                        style: TextStyle(
                            fontSize: _label,
                            color: (_page == 2)
                                ? Theme.of(context).accentColor
                                : Theme.of(context).textSelectionColor),
                      ),
                      icon: Icon(
                        Icons.call,
                        color: (_page == 2)
                            ? Theme.of(context).accentColor
                            : Theme.of(context).textSelectionColor,
                      ))
                ],
                onTap: navigationTapped,
                currentIndex: _page,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
