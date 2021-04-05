import 'package:flutter/material.dart';
import 'package:fingerpay/src/screen/dashboard.dart';
import 'package:fingerpay/src/screen/history.dart';
import 'package:fingerpay/src/screen/account.dart';
import 'package:fingerpay/src/screen/setting.dart';
import 'package:fingerpay/src/widget/fab_menuItem.dart';
import 'package:fingerpay/src/widget/fab_menu.dart';
import 'package:fingerpay/src/screen/myCard.dart';
import 'package:fingerpay/src/screen/topUp.dart';
import 'package:fingerpay/src/widget/provider_widget.dart';
import 'package:fingerpay/src/models/user.dart';
import 'createPayment.dart';
import 'package:fingerpay/src/screen/acceptScanningPage.dart';
import 'package:barcode_scan/barcode_scan.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String qrCode = '';
  int selectedIdx = 0;
  PageController _myPage = PageController(initialPage: 0);
  UserAccount user = UserAccount(0, '', '');
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: Text('Are you sure you want to quit?'),
                  actions: <Widget>[
                    ElevatedButton(
                        child: Text('Quit'),
                        onPressed: () => Navigator.of(context).pop(true)),
                    ElevatedButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(false)),
                  ])),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FutureBuilder(
          future: Provider.of(context).auth.getCurrent(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return menu(context, snapshot);
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Container(
            height: 60,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  color: selectedIdx == 0 ? Colors.black : Colors.grey,
                  iconSize: 30.0,
                  padding: EdgeInsets.only(left: 28.0, right: 28.0),
                  icon: Icon(Icons.home),
                  onPressed: () {
                    setState(() {
                      selectedIdx = 0;
                      _myPage.jumpToPage(0);
                    });
                  },
                ),
                IconButton(
                    color: selectedIdx == 1 ? Colors.black : Colors.grey,
                    iconSize: 30.0,
                    padding: EdgeInsets.only(left: 28.0, right: 28.0),
                    icon: Icon(Icons.person),
                    onPressed: () {
                      setState(() {
                        selectedIdx = 1;
                        _myPage.jumpToPage(1);
                      });
                    }),
                IconButton(
                    color: selectedIdx == 2 ? Colors.black : Colors.grey,
                    iconSize: 30.0,
                    padding: EdgeInsets.only(left: 28.0, right: 28.0),
                    icon: Icon(Icons.history),
                    onPressed: () {
                      setState(() {
                        selectedIdx = 2;
                        _myPage.jumpToPage(2);
                      });
                    }),
                IconButton(
                    color: selectedIdx == 3 ? Colors.black : Colors.grey,
                    iconSize: 30.0,
                    padding: EdgeInsets.only(left: 28.0, right: 28.0),
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      setState(() {
                        selectedIdx = 3;
                        _myPage.jumpToPage(3);
                      });
                    }),
              ],
            ),
          ),
        ),
        body: PageView(
          controller: _myPage,
          // onPageChanged: (int) {
          //   selectedIdx = int;
          // },
          children: <Widget>[
            Center(
              child: Container(
                child: Dashboard(),
              ),
            ),
            Center(
              child: Container(
                child: Account(),
              ),
            ),
            Center(
              child: Container(
                child: History(),
              ),
            ),
            Center(
              child: Container(
                child: Setting(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menu(context, snapshot) {
    _getProfileData() async {
      final uid = await Provider.of(context).auth.getCurrentUID();
      await Provider.of(context)
          .db
          .collection('user')
          .doc(uid)
          .get()
          .then((result) {
        user.balance = result.data()['balance'].toDouble();
      });
    }

    return FutureBuilder(
        future: _getProfileData(),
        builder: (context, snapshot) {
          return BoomMenu(
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            //child: Icon(Icons.add),
            onOpen: () => print('OPENING DIAL'),
            onClose: () => print('DIAL CLOSED'),
            scrollVisible: true,
            overlayColor: Colors.black,
            overlayOpacity: 0.7,
            children: [
              MenuItem(
                child: Icon(Icons.send, color: Colors.white),
                title: "Send",
                titleColor: Colors.white,
                subtitle: "You can send money to anyone",
                subTitleColor: Colors.white,
                backgroundColor: Colors.blue,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CreatePaymentPage(balance: user.balance)));
                },
              ),
              MenuItem(
                child: Icon(Icons.border_color, color: Colors.black),
                title: "Request",
                titleColor: Colors.black,
                subtitle: "Make a request to receive money",
                subTitleColor: Colors.black,
                backgroundColor: Colors.white,
                onTap: () async {
                  String codeSanner =
                      await BarcodeScanner.scan(); //barcode scnner
                  setState(() {
                    qrCode = codeSanner;
                  });
                  print(qrCode);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AcceptScanPage(
                                encrpytedtext: qrCode,
                              )));
                },
              ),
              MenuItem(
                child: Icon(Icons.monetization_on, color: Colors.white),
                title: "Top Up",
                titleColor: Colors.white,
                subtitle: "Top up money to your account",
                subTitleColor: Colors.white,
                backgroundColor: Colors.blue,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TopUpPage(balance: user.balance)));
                },
              ),
              MenuItem(
                child: Icon(Icons.credit_card, color: Colors.black),
                title: "My Card",
                titleColor: Colors.black,
                subtitle: "You can add a credit card or bank account",
                subTitleColor: Colors.black,
                backgroundColor: Colors.white,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreditCardsPage()));
                },
              )
            ],
          );
        });
  }
}
