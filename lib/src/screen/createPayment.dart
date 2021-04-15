import 'package:fingerpay/src/screen/paymentScanningPage.dart';
import 'package:fingerpay/src/widget/cal_button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CreatePaymentPage extends StatefulWidget {
  final double balance;
  const CreatePaymentPage({Key key, this.balance}) : super(key: key);

  @override
  _CreatePaymentPageState createState() => _CreatePaymentPageState();
}

class _CreatePaymentPageState extends State<CreatePaymentPage> {
  String _history = '';
  String _expression = '';
  bool _pay = true;

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

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        if (_expression == '') {
          Fluttertoast.showToast(
            msg: "Please input a number",
            gravity: ToastGravity.CENTER,
          );
        } else if (double.parse(_expression) <= 0) {
          Fluttertoast.showToast(
            msg: "Value rejected",
            gravity: ToastGravity.CENTER,
          );
        } else if (_pay && double.parse(_expression) > widget.balance) {
          Fluttertoast.showToast(
            msg: "Not enough balance, please top up",
            gravity: ToastGravity.CENTER,
          );
        } else {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PaymentScanPage(
                        pay: _pay,
                        amount: double.parse(_expression),
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

  void numClick(String text) {
    setState(() => _expression += text);
  }

  void allClear(String text) {
    setState(() {
      _history = '';
      _expression = '';
    });
  }

  void clear(String text) {
    setState(() {
      _expression = '';
    });
  }

  void evaluate(String text) {
    Parser p = Parser();
    Expression exp = p.parse(_expression);
    ContextModel cm = ContextModel();

    setState(() {
      _history = _expression;
      _expression = exp.evaluate(EvaluationType.REAL, cm).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3884e0),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 120.0, bottom: 4.0, left: 10),
                    alignment: Alignment.center,
                    child: ToggleSwitch(
                        minWidth: 90.0,
                        cornerRadius: 20,
                        activeBgColor: Colors.grey,
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.white,
                        inactiveFgColor: Colors.grey,
                        labels: ['Pay', 'Recieve'],
                        icons: [Icons.send, Icons.border_color],
                        onToggle: (index) {
                          if (index == 1) {
                            _pay = false;
                          } else {
                            _pay = true;
                          }
                          print('switched to: $index');
                        }),
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: "\nCurrent Balance\n",
                            style:
                                TextStyle(color: Colors.white, fontSize: 30)),
                        TextSpan(
                            text: "\$ ",
                            style:
                                TextStyle(color: Colors.white, fontSize: 43)),
                        TextSpan(
                            text: "${widget.balance}\n",
                            style:
                                TextStyle(color: Colors.white, fontSize: 50)),
                      ])),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      _history,
                      style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                          fontSize: 24,
                          color: Color(0xFF545F61),
                        ),
                      ),
                    ),
                  ),
                  alignment: Alignment(1.0, 1.0),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      _expression,
                      style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  alignment: Alignment(1.0, 1.0),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CalcButton(
                      text: 'AC',
                      fillColor: 0xff3884e0,
                      textSize: 20,
                      textColor: 0xFFa7c8f1,
                      callback: allClear,
                    ),
                    CalcButton(
                      text: 'C',
                      fillColor: 0xff3884e0,
                      textColor: 0xFFa7c8f1,
                      callback: clear,
                    ),
                    CalcButton(
                      text: '%',
                      fillColor: 0xFFFFFFFF,
                      textColor: 0xFF7badea,
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '/',
                      fillColor: 0xFFFFFFFF,
                      textColor: 0xFF7badea,
                      callback: numClick,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CalcButton(
                      text: '7',
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '8',
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '9',
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '*',
                      fillColor: 0xFFFFFFFF,
                      textColor: 0xFF7badea,
                      textSize: 24,
                      callback: numClick,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CalcButton(
                      text: '4',
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '5',
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '6',
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '-',
                      fillColor: 0xFFFFFFFF,
                      textColor: 0xFF7badea,
                      textSize: 38,
                      callback: numClick,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CalcButton(
                      text: '1',
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '2',
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '3',
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '+',
                      fillColor: 0xFFFFFFFF,
                      textColor: 0xFF7badea,
                      textSize: 30,
                      callback: numClick,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CalcButton(
                      text: '.',
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '0',
                      callback: numClick,
                    ),
                    CalcButton(
                      text: '00',
                      callback: numClick,
                      textSize: 26,
                    ),
                    CalcButton(
                      text: '=',
                      fillColor: 0xFFFFFFFF,
                      textColor: 0xFF7badea,
                      callback: evaluate,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                _submitButton(),
              ],
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    );
  }
}
