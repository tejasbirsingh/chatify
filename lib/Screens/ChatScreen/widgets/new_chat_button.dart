import 'package:flutter/material.dart';

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      width: 60.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.redAccent, Colors.red.shade400],
        ),
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Center(
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 20.0,
        ),
      ),
    );
  }
}
