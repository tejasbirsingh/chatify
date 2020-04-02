import 'package:flutter/material.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final Widget title;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;


  CustomAppBar({
    Key key,
    @required this.title,
    @required this.actions,
    @required this.leading,
    @required this.centerTitle})
      : super(key :key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 1.4,
            style: BorderStyle.solid
          )
        )
      ),
      child: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading:leading,
        actions: actions,
        centerTitle: centerTitle,
        title: title,
      ),
    );
  }

  final Size preferredSize  = const Size.fromHeight(kToolbarHeight + 10);
}