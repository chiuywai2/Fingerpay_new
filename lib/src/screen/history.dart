import 'package:fingerpay/src/widget/historyItem.dart';
import 'package:flutter/material.dart';
import 'package:fingerpay/src/widget/topbar.dart';
import 'package:fingerpay/src/common.dart';
import 'package:fingerpay/src/widget/provider_widget.dart';
import 'package:fingerpay/src/models/user.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  UserAccount user = UserAccount(0, '', '');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of(context).auth.getCurrent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return history(context, snapshot);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget history(context, snapshot) {
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

    return Scaffold(
      backgroundColor: white,
      body: Container(
        child: Stack(children: <Widget>[
          Topbar(
            barHeight: 175,
          ),
          SafeArea(
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FutureBuilder(
                        future: _getProfileData(),
                        builder: (context, snapshot) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                                text: TextSpan(children: [
                              TextSpan(
                                  text: "\nTotal Balance\n",
                                  style: TextStyle(color: white, fontSize: 18)),
                              TextSpan(
                                  text: "\$ ",
                                  style: TextStyle(color: white, fontSize: 30)),
                              TextSpan(
                                  text: "${user.balance}\n",
                                  style: TextStyle(color: white, fontSize: 36)),
                            ])),
                          );
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: white,
                          size: 40,
                        ),
                        onPressed: () {})
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "History",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 650,
                  child: ListView(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    children: <Widget>[
                      HistoryItem(
                          iconPath: 'p3.jpg',
                          money: -430,
                          name: 'Kenny Chiu',
                          date: DateTime.parse("2020-12-24 20:18:00")),
                      HistoryItem(
                          iconPath: 'p3.jpg',
                          money: -430,
                          name: 'Kenny Chiu',
                          date: DateTime.parse("2020-12-24 20:18:00")),
                      HistoryItem(
                          iconPath: 'p2.jpg',
                          money: -200,
                          name: 'William',
                          date: DateTime.parse("2020-12-20 20:18:00")),
                      HistoryItem(
                          iconPath: 'p3.jpg',
                          money: -430,
                          name: 'Kenny Chiu',
                          date: DateTime.parse("2020-12-24 20:18:00")),
                      HistoryItem(
                          iconPath: 'p2.jpg',
                          money: -200,
                          name: 'William',
                          date: DateTime.parse("2020-12-20 20:18:00")),
                      HistoryItem(
                          iconPath: 'p2.jpg',
                          money: -200,
                          name: 'William',
                          date: DateTime.parse("2020-12-20 20:18:00")),
                      HistoryItem(
                          iconPath: 'p2.jpg',
                          money: -200,
                          name: 'William',
                          date: DateTime.parse("2020-12-20 20:18:00")),
                      HistoryItem(
                          iconPath: 'p2.jpg',
                          money: -200,
                          name: 'William',
                          date: DateTime.parse("2020-12-20 20:18:00")),
                      HistoryItem(
                          iconPath: 'p2.jpg',
                          money: -200,
                          name: 'William',
                          date: DateTime.parse("2020-12-20 20:18:00")),
                      HistoryItem(
                          iconPath: 'p2.jpg',
                          money: -200,
                          name: 'William',
                          date: DateTime.parse("2020-12-20 20:18:00")),
                      HistoryItem(
                          iconPath: 'p2.jpg',
                          money: -200,
                          name: 'William',
                          date: DateTime.parse("2020-12-20 20:18:00")),
                      HistoryItem(
                          iconPath: 'p2.jpg',
                          money: -200,
                          name: 'William',
                          date: DateTime.parse("2020-12-20 20:18:00")),
                      HistoryItem(
                          iconPath: 'p2.jpg',
                          money: -200,
                          name: 'William',
                          date: DateTime.parse("2020-12-20 20:18:00")),
                      HistoryItem(
                          iconPath: 'p2.jpg',
                          money: -200,
                          name: 'William',
                          date: DateTime.parse("2020-12-20 20:18:00")),
                    ],
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
