import 'dart:ui';
import 'package:fingerpay/src/screen/qrcode.dart';
import 'package:fingerpay/src/service/auth_service.dart';
import 'package:fingerpay/src/widget/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hand_tracking_plugin/HandGestureRecognition.dart';
import 'package:flutter_hand_tracking_plugin/flutter_hand_tracking_plugin.dart';
import 'package:flutter_hand_tracking_plugin/gen/landmark.pb.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PaymentScanPage extends StatefulWidget {
  final bool pay;
  final double amount;

  const PaymentScanPage({Key key, this.pay, this.amount}) : super(key: key);

  @override
  _PaymentScanPageState createState() => _PaymentScanPageState();
}

class _PaymentScanPageState extends State<PaymentScanPage> {
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
            Text('Back',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white))
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
        if (percent != 100.0) {
          Fluttertoast.showToast(
            msg: 'Please finish the scanning',
            gravity: ToastGravity.CENTER,
          );
        } else {
          String uid = await AuthService().getCurrentUID();
          await Provider.of(context)
              .db
              .collection('user')
              .doc(uid)
              .get()
              .then((result) {
            setState(() {
              fullname = result.data()['fullname'].toString();
            });
          });
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => QRCode(
                        pay: widget.pay,
                        amount: widget.amount,
                        uid: uid,
                        gesture: detected1 + detected2,
                        fullname: fullname,
                      )));
        }
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

  Widget _scanButton(String gesture) {
    return InkWell(
      onTap: () {
        if (percent == 0.0) {
          detected1 = _detected;
          setState(() {
            percent += 50;
            scan = 'Scan the second gesture';
          });
          print(detected1);
        } else if (percent == 50.0) {
          setState(() {
            detected2 = _detected;
            percent += 50;
            scan = 'Scan again';
          });
          print(detected2);
        } else {
          setState(() {
            percent -= 100;
            scan = 'Scan the first gesture';
          });
        }
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
          scan,
          style: TextStyle(fontSize: 20, color: Color(0xFF3884e0)),
        ),
      ),
    );
  }

  HandTrackingViewController _controller;
  Gestures _gesture;
  String _detected;
  String detected1;
  String detected2;
  double percent = 0.0;
  String fullname;
  String scan = 'Scan the first gesture';

  // Color _selectedColor = Colors.black;
  // Color _pickerColor = Colors.black;
  // double _opacity = 1.0;
  // double _strokeWidth = 3.0;
  // double _canvasHeight = 300;
  // double _canvasWeight = 300;

  // bool _showBottomList = false;
  // List<DrawingPoints> _points = List();
  // SelectedMode _selectedMode = SelectedMode.StrokeWidth;

  // List<Color> _colors = [
  //   Colors.red,
  //   Colors.green,
  //   Colors.blue,
  //   Colors.amber,
  //   Colors.black
  // ];

  // void continueDraw(landmark) => setState(() => _points.add(DrawingPoints(
  //     points: Offset(landmark.x * _canvasWeight, landmark.y * _canvasHeight),
  //     paint: Paint()
  //       ..strokeCap = StrokeCap.butt
  //       ..isAntiAlias = true
  //       ..color = _selectedColor.withOpacity(_opacity)
  //       ..strokeWidth = _strokeWidth)));

  // void finishDraw() => setState(() => _points.add(null));

  void _onLandMarkStream(NormalizedLandmarkList landmarkList) {
    if (landmarkList.landmark != null && landmarkList.landmark.length != 0) {
      setState(() => _gesture =
          HandGestureRecognition.handGestureRecognition(landmarkList.landmark));
      _detected =
          HandGestureRecognition.handGestureNumber(landmarkList.landmark);
      // if (_gesture == Gestures.ONE)
      //   continueDraw(landmarkList.landmark[8]);
      // else if (_points.length != 0) finishDraw();
    } else
      _gesture = null;
  }

  // getColorList() {
  //   List<Widget> listWidget = List();
  //   for (Color color in _colors) {
  //     listWidget.add(colorCircle(color));
  //   }
  //   Widget colorPicker = GestureDetector(
  //     child: ClipOval(
  //       child: Container(
  //         padding: const EdgeInsets.only(bottom: 16.0),
  //         height: 36,
  //         width: 36,
  //         decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //           colors: [Colors.red, Colors.green, Colors.blue],
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         )),
  //       ),
  //     ),
  //   );
  //   listWidget.add(colorPicker);
  //   return listWidget;
  // }

  // Widget colorCircle(Color color) {
  //   return GestureDetector(
  //     onTap: () => setState(() => _selectedColor = color),
  //     child: ClipOval(
  //       child: Container(
  //         padding: const EdgeInsets.only(bottom: 16.0),
  //         height: 36,
  //         width: 36,
  //         color: color,
  //       ),
  //     ),
  //   );
  // }

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
                  if (_controller != null)
                    _controller.landMarksStream.listen(_onLandMarkStream);
                }),
              ),
            ),
            _controller == null
                ? Text(
                    "Please grant camera permissions and reopen the application.")
                : Column(
                    children: <Widget>[
                      Text(_gesture == null ? "No hand landmarks." : _detected),
                      // : _gesture.toString() + _detected),
                    ],
                  ),
            Container(
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  LinearPercentIndicator(
                    animation: true,
                    animationDuration: 1000,
                    lineHeight: 20.0,
                    percent: percent / 100,
                    center: Text(
                      percent.toString() + "%",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: Colors.blue[400],
                    backgroundColor: Colors.grey[300],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _scanButton(_gesture.toString()),
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

// class DrawingPainter extends CustomPainter {
//   DrawingPainter({this.pointsList});

//   List<DrawingPoints> pointsList;
//   List<Offset> offsetPoints = [];

//   @override
//   void paint(Canvas canvas, Size size) {
//     for (int i = 0; i < pointsList.length - 1; i++) {
//       if (pointsList[i] != null && pointsList[i + 1] != null) {
//         canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
//             pointsList[i].paint);
//       } else if (pointsList[i] != null && pointsList[i + 1] == null) {
//         offsetPoints.clear();
//         offsetPoints.add(pointsList[i].points);
//         offsetPoints.add(Offset(
//             pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));
//         canvas.drawPoints(PointMode.points, offsetPoints, pointsList[i].paint);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(DrawingPainter oldDelegate) => true;
// }

// class DrawingPoints {
//   Paint paint;
//   Offset points;

//   DrawingPoints({this.points, this.paint});
// }

// enum SelectedMode { StrokeWidth, Opacity, Color }
