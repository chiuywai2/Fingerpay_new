import 'dart:ui';

import 'package:fingerpay/src/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hand_tracking_plugin/HandGestureRecognition.dart';
import 'package:flutter_hand_tracking_plugin/flutter_hand_tracking_plugin.dart';
import 'package:flutter_hand_tracking_plugin/gen/landmark.pb.dart';

import 'acceptPayment.dart';

class AcceptScanPage extends StatefulWidget {
  final String encrpytedtext;

  const AcceptScanPage({Key key, this.encrpytedtext}) : super(key: key);

  @override
  _AcceptScanPageState createState() => _AcceptScanPageState();
}

class _AcceptScanPageState extends State<AcceptScanPage> {
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.white),
            ),
            Text('Back', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget _submitButton(String gesture) {
    print('-----------------');
    print(_gesture);
    print(gesture);
    print('-----------------');
    return InkWell(
      onTap: () async {
        String uid = await AuthService().getCurrentUID();
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AcceptPay(
                      encrpytedtext: widget.encrpytedtext,
                      gesture: gesture,
                    )));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xffffffff), Color(0xffffffff)])),
        child: Text(
          'Next',
          style: TextStyle(fontSize: 20, color: Color(0xFF3884e0)),
        ),
      ),
    );
  }

  HandTrackingViewController _controller;
  Gestures _gesture;

  Color _selectedColor = Colors.black;
  Color _pickerColor = Colors.black;
  double _opacity = 1.0;
  double _strokeWidth = 3.0;
  double _canvasHeight = 300;
  double _canvasWeight = 300;

  bool _showBottomList = false;
  List<DrawingPoints> _points = List();
  SelectedMode _selectedMode = SelectedMode.StrokeWidth;

  List<Color> _colors = [Colors.red, Colors.green, Colors.blue, Colors.amber, Colors.black];

  void continueDraw(landmark) => setState(() => _points.add(DrawingPoints(
      points: Offset(landmark.x * _canvasWeight, landmark.y * _canvasHeight),
      paint: Paint()
        ..strokeCap = StrokeCap.butt
        ..isAntiAlias = true
        ..color = _selectedColor.withOpacity(_opacity)
        ..strokeWidth = _strokeWidth)));

  void finishDraw() => setState(() => _points.add(null));

  void _onLandMarkStream(NormalizedLandmarkList landmarkList) {
    if (landmarkList.landmark != null && landmarkList.landmark.length != 0) {
      setState(() => _gesture = HandGestureRecognition.handGestureRecognition(landmarkList.landmark));
      if (_gesture == Gestures.ONE)
        continueDraw(landmarkList.landmark[8]);
      else if (_points.length != 0) finishDraw();
    } else
      _gesture = null;
  }

  getColorList() {
    List<Widget> listWidget = List();
    for (Color color in _colors) {
      listWidget.add(colorCircle(color));
    }
    Widget colorPicker = GestureDetector(
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.red, Colors.green, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )),
        ),
      ),
    );
    listWidget.add(colorPicker);
    return listWidget;
  }

  Widget colorCircle(Color color) {
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 600,
              child: HandTrackingView(
                onViewCreated: (HandTrackingViewController c) => setState(() {
                  _controller = c;
                  if (_controller != null) _controller.landMarksStream.listen(_onLandMarkStream);
                }),
              ),
            ),
            _controller == null
                ? Text("Please grant camera permissions and reopen the application.")
                : Column(
                    children: <Widget>[
                      Text(_gesture == null ? "No hand landmarks." : _gesture.toString()),
                    ],
                  ),
            Container(
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  _submitButton(_gesture.toString()),
                ],
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList});

  List<DrawingPoints> pointsList;
  List<Offset> offsetPoints = List();

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points, pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
        canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}

class DrawingPoints {
  Paint paint;
  Offset points;

  DrawingPoints({this.points, this.paint});
}

enum SelectedMode { StrokeWidth, Opacity, Color }
