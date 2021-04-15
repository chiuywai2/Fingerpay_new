import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fingerpay/src/widget/provider_widget.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'home.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class QRCode extends StatefulWidget {
  final String uid;
  final double amount;
  final bool pay;
  final String gesture;
  final String fullname;

  const QRCode(
      {Key key, this.uid, this.amount, this.pay, this.gesture, this.fullname})
      : super(key: key);

  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  String encrpyText;
  String collectionid;

  initState() {
    super.initState();
    encrypt(widget.uid +
        ',' +
        widget.amount.toString() +
        ',' +
        widget.pay.toString() +
        ',' +
        widget.gesture +
        ',' +
        (widget.fullname == 'null' ? 'Anonymous User' : widget.fullname));
  }

  Future<void> encrypt(String encrypttext) async {
    PlatformStringCryptor cryptor = PlatformStringCryptor();
    final key = await cryptor.generateRandomKey();
    final encrypted = await cryptor.encrypt(encrypttext, key);
    await FirebaseFirestore.instance.collection("keys").add({
      "key": key,
    }).then((value) {
      setState(() {
        collectionid = value.id;
      });
    });
    setState(() {
      encrpyText = encrypted;
    });
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

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        Navigator.pop(context);
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
    return Scaffold(
      backgroundColor: Color(0xFF3884e0),
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(widget.gesture),
                QrImage(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF3884e0),
                    data: collectionid + ',' + encrpyText,
                    version: QrVersions.auto,
                    size: 350.0),
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
