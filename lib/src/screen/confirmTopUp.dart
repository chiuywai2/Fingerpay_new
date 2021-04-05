import 'package:fingerpay/src/screen/home.dart';
import 'package:fingerpay/src/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:fingerpay/src/widget/provider_widget.dart';
import 'package:fingerpay/src/service/database_service.dart';

class ConfirmTopUp extends StatefulWidget {
  final double balance;
  final double topUpValue;

  const ConfirmTopUp({Key key, this.balance, this.topUpValue})
      : super(key: key);

  @override
  _ConfirmTopUpState createState() => _ConfirmTopUpState();
}

class _ConfirmTopUpState extends State<ConfirmTopUp> {
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
      onTap: () async {
        String uid = await AuthService().getCurrentUID();
        await DatabaseService(uid: uid)
            .updatebalance(widget.balance + widget.topUpValue);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
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
          'Top Up',
          style: TextStyle(fontSize: 20, color: Color(0xFF3884e0)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of(context).auth.getCurrent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return confirm(context, snapshot);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget confirm(context, snapshot) {
    return Scaffold(
      backgroundColor: Color(0xFF3884e0),
      body: Container(
        child: Stack(children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 80),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "\nCurrent Balance\n",
                          style: TextStyle(color: Colors.white, fontSize: 30)),
                      TextSpan(
                          text: "\$ ",
                          style: TextStyle(color: Colors.white, fontSize: 43)),
                      TextSpan(
                          text: "${widget.balance}\n\n",
                          style: TextStyle(color: Colors.white, fontSize: 50)),
                      TextSpan(
                          text: "\nBalance After Top Up\n",
                          style: TextStyle(color: Colors.white, fontSize: 30)),
                      TextSpan(
                          text: "\$ ",
                          style: TextStyle(color: Colors.white, fontSize: 43)),
                      TextSpan(
                          text: "${widget.balance + widget.topUpValue}\n",
                          style: TextStyle(color: Colors.white, fontSize: 50)),
                    ])),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _submitButton(),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ]),
      ),
    );
  }
}
