import 'package:flutter/material.dart';

class Topbar extends StatefulWidget {
  final double barHeight;

  @override
  Topbar({this.barHeight});
  State<StatefulWidget> createState() => _TopbarState();
}

class _TopbarState extends State<Topbar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: _AppBarClipper(),
          child: Container(
            padding: const EdgeInsets.only(top: 48),
            color: Theme.of(context).primaryColor,
            height: widget.barHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[],
            ),
          ),
        ),
      ],
    );
  }
}

class _AppBarClipper extends CustomClipper<Path> {
  _AppBarClipper();

  @override
  Path getClip(Size size) {
    double height = size.height;
    Path path = Path();

    path.moveTo(0, height - 40);
    path.quadraticBezierTo(size.width / 2, height, size.width, height - 40);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
