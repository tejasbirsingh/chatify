import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget icon;
  final Widget subtitle;
  final Widget trailing;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final bool isRequest;
  final GestureTapCallback requestButtonPress;
  final GestureTapCallback requestLongPress;

  const CustomTile({
    Key key,
    @required this.leading,
    @required this.title,
    this.icon,
    @required this.subtitle,
    this.trailing,

    this.margin = const EdgeInsets.all(0),
    this.mini = true,
    this.onTap,
    this.onLongPress,
    this.isRequest,
    this.requestButtonPress,
    this.requestLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: mini ? 30 : 0),
      margin: margin,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Stack(
              children: <Widget>[
                leading,

              ],
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          GestureDetector(
            onTap: onTap,
            onLongPress: onLongPress,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: mini ? 3 : 20),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                width: 1,
                color: Colors.grey,
              ))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      title,
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          icon ?? Container(),
                          subtitle,
                        ],
                      )
                    ],
                  ),
                  trailing ?? Container(),
                  SizedBox(
                    width: 20.0,
                  ),
                  isRequest == true
                      ? GestureDetector(
                          onTap: requestButtonPress,
                          onLongPress: requestLongPress,
                          child: Container(
                            height: 30.0,
                            width: 30.0,
                            decoration: BoxDecoration(
                                color: Theme.of(context).iconTheme.color,
                                shape: BoxShape.circle),
                            child: Center(
                                child: Icon(
                              Icons.add,
                              color: Colors.white,
                            )),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
