import 'package:flutter/material.dart';
import 'package:video_chatting_app/resources/firebase_repository.dart';

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
  final Color live;

  const CustomTile(
      {Key key,
      @required this.leading,
      @required this.title,
      this.icon,
      @required this.subtitle,
      this.trailing,
        this.live,
      this.margin = const EdgeInsets.all(0),
      this.mini = true,
      this.onTap,
      this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(

          padding: EdgeInsets.symmetric(horizontal: mini ? 30 : 0),
          margin: margin,
          child: Row(

            children: <Widget>[
              Stack(
                children: <Widget>[

                  leading,
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: Container(
                      height: 10.0,
                      width: 10.0,

                      decoration: BoxDecoration(
                        color:live,
                        borderRadius: BorderRadius.circular(20.0),

                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10.0,),
              Expanded(
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
                         title ,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
