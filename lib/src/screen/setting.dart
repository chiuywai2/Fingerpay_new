import 'package:flutter/material.dart';
import 'package:fingerpay/src/widget/topbar.dart';
import 'package:fingerpay/src/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:fingerpay/src/service/auth_service.dart';
import 'package:fingerpay/src/widget/provider_widget.dart';
import 'package:fingerpay/src/models/user.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  UserAccount user = UserAccount(0, '', '');
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of(context).auth.getCurrent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return setting(context, snapshot);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget setting(context, snapshot) {
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
                        "Setting",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Account",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Divider(
                  height: 15,
                  thickness: 2,
                ),
                SizedBox(
                  height: 5,
                ),
                buildAccountOptionRow(context, "Transaction Limit"),
                buildAccountOptionRow(context, "Credit Card or Bank Account"),
                buildAccountOptionRow(context, "Contact Us"),
                buildAccountOptionRow(context, "Language"),
                buildAccountOptionRow(context, "Privacy and security"),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.volume_up_outlined,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Notifications",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Divider(
                  height: 15,
                  thickness: 2,
                ),
                SizedBox(
                  height: 5,
                ),
                buildNotificationOptionRow("Top Up", false),
                buildNotificationOptionRow("New Request", true),
                buildNotificationOptionRow("New Transcation", false),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () async {
                      await AuthService().signOut();
                    },
                    child: Text("SIGN OUT",
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildNotificationOptionRow(String title, bool isActive) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600]),
          ),
          Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                value: isActive,
                onChanged: (bool val) {},
              ))
        ],
      ),
    );
  }

  Widget buildAccountOptionRow(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(title),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Option 1"),
                      Text("Option 2"),
                      Text("Option 3"),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("Close")),
                  ],
                );
              });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
