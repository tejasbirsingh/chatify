import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final Color color;
  final List<Widget> actions;
  final Widget leading;
  final bool centerTitle;

  CustomAppBar({
    Key key,
    this.title,
    @required this.actions,
    this.color,
     this.leading,
    @required this.centerTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: color,
        elevation: 0.0,
        leading: leading,
        actions: actions,
        centerTitle: centerTitle,
        title: title)
    ;
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 0);
}
