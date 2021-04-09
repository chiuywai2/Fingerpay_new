import 'package:fingerpay/src/service/database_service.dart';
import 'package:fingerpay/src/widget/profileIcon.dart';
import 'package:flutter/material.dart';
import 'package:fingerpay/src/common.dart';
import 'package:intl/intl.dart';

class HistoryItem extends StatefulWidget {
  final double money;
  final DateTime date;
  final String uid;

  @override
  HistoryItem({this.uid, this.money, this.date});
  State<StatefulWidget> createState() => _HistoryItem();
}

class _HistoryItem extends State<HistoryItem> {
  String name;
  String icnonPath;

  String _getUserName(String uid) {
    DatabaseService(uid: uid).getUserName(uid).then((result) {
      setState(() {
        name = result;
      });
    });
    return name;
  }

  // String _getIconPath(String uid) {
  //   DatabaseService(uid: uid).getIconpath(uid).then((result) {
  //     setState(() {
  //       icnonPath = result;
  //     });
  //   });
  //   return icnonPath;
  // }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showHistory(context);
      },
      leading: ProfileIcon(
        image: 'anonymous.jpg',
      ),
      title: RichText(
        text: TextSpan(children: [
          TextSpan(
              text: _getUserName(widget.uid) == null
                  ? 'Anonymous User \n'
                  : _getUserName(widget.uid) + '\n'),
          TextSpan(
              text: widget.money < 0
                  ? 'Money Sent - ' +
                      DateFormat('yyyy-MM-dd HH:mm').format(widget.date)
                  : 'Money Received - ' +
                      DateFormat('yyyy-MM-dd HH:mm').format(widget.date),
              style: TextStyle(fontSize: 14, color: grey)),
        ], style: TextStyle(color: Colors.black, fontSize: 18)),
      ),
      trailing: Text(
        widget.money.toString(),
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  void showHistory(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            child: new Wrap(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            AssetImage('assets/images/anonymous.jpg'),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    _getUserName(widget.uid) == null
                        ? 'Anonymous User \n'
                        : _getUserName(widget.uid),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    widget.money < 0
                        ? 'Money Sent - ' +
                            DateFormat('yyyy-MM-dd HH:mm').format(widget.date)
                        : 'Money Received - ' +
                            DateFormat('yyyy-MM-dd HH:mm').format(widget.date),
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.money.toString(),
                      style:
                          TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
