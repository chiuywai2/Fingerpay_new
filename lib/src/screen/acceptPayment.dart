import 'package:fingerpay/src/models/user.dart';
import 'package:fingerpay/src/service/auth_service.dart';
import 'package:fingerpay/src/service/database_service.dart';
import 'package:fingerpay/src/widget/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'home.dart';

class AcceptPay extends StatefulWidget {
  final String encrpytedtext;

  const AcceptPay({Key key, this.encrpytedtext}) : super(key: key);

  @override
  _AcceptPayState createState() => _AcceptPayState();
}

class _AcceptPayState extends State<AcceptPay> {
  UserAccount user1 = UserAccount(0, '', '');
  UserAccount user2 = UserAccount(0, '', '');

  List<String> getdata(String encrpytedtext) {
    List<String> decryptedtext;

    decryptedtext = encrpytedtext.split(',');

    return decryptedtext;
  }

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

  Widget _submitButton(String targetuid, bool pay, double amount) {
    return InkWell(
      onTap: () async {
        String uid = await AuthService().getCurrentUID();
        await Provider.of(context)
            .db
            .collection('user')
            .doc(uid)
            .get()
            .then((result) {
          user1.balance = result.data()['balance'].toDouble();
        });
        await Provider.of(context)
            .db
            .collection('user')
            .doc(targetuid)
            .get()
            .then((result) {
          user2.balance = result.data()['balance'].toDouble();
        });
        if (pay && user2.balance < amount) {
          Fluttertoast.showToast(
            msg: "Payer dont have enough balance, please topup",
            gravity: ToastGravity.CENTER,
          );
        } else if (!pay && user1.balance < amount) {
          Fluttertoast.showToast(
            msg: "Dont have enough balance, please topup",
            gravity: ToastGravity.CENTER,
          );
        } else {
          await DatabaseService(uid: targetuid).updatebalance(
              pay ? user2.balance - amount : user2.balance + amount);
          await DatabaseService(uid: uid).updatebalance(
              pay ? user1.balance + amount : user1.balance - amount);
          await DatabaseService(uid: uid)
              .transactionRecord(targetuid, amount, DateTime.now(), pay);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
          Navigator.pop(context);
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
          'Finish',
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
          return qr(context, snapshot);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget qr(context, snapshot) {
    List<String> decrpytedtext = getdata(widget.encrpytedtext);
    return Scaffold(
      backgroundColor: Color(0xFF3884e0),
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: (decrpytedtext[2] == 'true'
                            ? 'Recieve :\n'
                            : 'Pay :\n'),
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                    TextSpan(
                        text: "\$ ",
                        style: TextStyle(color: Colors.white, fontSize: 43)),
                    TextSpan(
                        text: decrpytedtext[1],
                        style: TextStyle(color: Colors.white, fontSize: 50)),
                    TextSpan(
                        text: "\nFrom\n",
                        style: TextStyle(color: Colors.white, fontSize: 30)),
                    TextSpan(
                        text: decrpytedtext[4],
                        style: TextStyle(color: Colors.white, fontSize: 50)),
                  ])),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                _submitButton(decrpytedtext[0], decrpytedtext[2] == 'true',
                    double.parse(decrpytedtext[1])),
              ],
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    );
  }
}
