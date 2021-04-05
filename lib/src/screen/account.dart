import 'package:flutter/material.dart';
import 'package:fingerpay/src/widget/topbar.dart';
import 'package:fingerpay/src/common.dart';
import 'package:fingerpay/src/widget/provider_widget.dart';
import 'package:fingerpay/src/models/user.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool showPassword = false;
  UserAccount user = UserAccount(0, '', '');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of(context).auth.getCurrent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return displayUserInformation(context, snapshot);
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget displayUserInformation(context, snapshot) {
    final authData = snapshot.data;

    _getProfileData() async {
      final uid = await Provider.of(context).auth.getCurrentUID();
      await Provider.of(context)
          .db
          .collection('user')
          .doc(uid)
          .get()
          .then((result) {
        user.balance = result.data()['balance'].toDouble();
        user.fullname = result.data()['fullname'];
        user.phone = result.data()['phone'];
      });
    }

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
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
                                    style:
                                        TextStyle(color: white, fontSize: 18)),
                                TextSpan(
                                    text: "\$ ",
                                    style:
                                        TextStyle(color: white, fontSize: 30)),
                                TextSpan(
                                    text: "${user.balance}\n",
                                    style:
                                        TextStyle(color: white, fontSize: 36)),
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
                          "Personal Profile",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 10))
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      "${authData.photoURL ?? 'assets/images/anonymous.jpg'}"))),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Colors.blue,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  buildTextField("User Name",
                      "${authData.displayName ?? 'Anonymous'}", false),
                  FutureBuilder(
                      future: _getProfileData(),
                      builder: (context, snapshot) {
                        return buildTextField(
                            "Full Name", "${user.fullname ?? 'Try'}", false);
                      }),
                  buildTextField(
                      "E-mail", "${authData.email ?? 'Anonymous'}", false),
                  FutureBuilder(
                      future: _getProfileData(),
                      builder: (context, snapshot) {
                        return buildTextField("Phone Number",
                            "${user.phone ?? '12345678'}", false);
                      }),
                  buildTextField("Password", "********", true),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {},
                          child: Text("CANCEL",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.black)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {},
                          child: Text(
                            "SAVE",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0, left: 8.0, right: 8.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}
