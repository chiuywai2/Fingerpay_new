import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  final String image;

  ProfileIcon({this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(2.0),
        child: CircleAvatar(
          backgroundImage: AssetImage("assets/images/$image"),
        ));
  }
}
