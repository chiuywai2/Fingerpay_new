import 'package:flutter/material.dart';
import 'package:fingerpay/src/widget/bezierContainer.dart';
import 'package:fingerpay/src/widget/cards.dart';

class CreditCardsPage extends StatefulWidget {
  CreditCardsPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CreditCardsPageState createState() => _CreditCardsPageState();
}

class _CreditCardsPageState extends State<CreditCardsPage> {
  final _formKey = GlobalKey<FormState>();
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
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  // Build the title section
  Column _buildTitleSection({@required title, @required subTitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 16.0),
          child: Text(
            '$title',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
          child: Text(
            '$subTitle',
            style: TextStyle(fontSize: 21, color: Colors.black45),
          ),
        )
      ],
    );
  }

// Build the FloatingActionButton
  Container _buildAddCardButton({
    @required Icon icon,
    @required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 24.0),
      alignment: Alignment.center,
      child: FloatingActionButton(
        elevation: 2.0,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Positioned(
                          right: -30,
                          top: -70,
                          child: InkResponse(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: CircleAvatar(
                              child: Icon(Icons.close),
                              backgroundColor: Colors.blue,
                            ),
                          )),
                      Form(
                        key: _formKey,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.credit_card),
                                        labelText: 'Card Number',
                                      ),
                                      onSaved: (String value) {
                                        // This optional block of code can be used to run
                                        // code when the user saves the form.
                                      },
                                      validator: (String value) {
                                        return value.contains('@')
                                            ? 'Do not use the @ char.'
                                            : null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.person),
                                        labelText: 'Card Owner',
                                      ),
                                      onSaved: (String value) {
                                        // This optional block of code can be used to run
                                        // code when the user saves the form.
                                      },
                                      validator: (String value) {
                                        return value.contains('@')
                                            ? 'Do not use the @ char.'
                                            : null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Flexible(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.calendar_today),
                                        labelText: 'Exp. Day',
                                      ),
                                      onSaved: (String value) {
                                        // This optional block of code can be used to run
                                        // code when the user saves the form.
                                      },
                                      validator: (String value) {
                                        return value.contains('@')
                                            ? 'Do not use the @ char.'
                                            : null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        icon: Icon(Icons.lock),
                                        labelText: 'CVV',
                                      ),
                                      onSaved: (String value) {
                                        // This optional block of code can be used to run
                                        // code when the user saves the form.
                                      },
                                      validator: (String value) {
                                        return value.contains('@')
                                            ? 'Do not use the @ char.'
                                            : null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  child: Text("add"),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                    }
                                  },
                                ),
                              ),
                            ]),
                      ),
                    ],
                  ),
                );
              });
        },
        backgroundColor: color,
        mini: false,
        child: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _buildTitleSection(
                          title: "Your Credit Card",
                          subTitle: "Select credit card for this account"),
                      Container(
                        alignment: Alignment.center,
                        child: Container(
                          height: 450,
                          width: 350,
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            children: <Widget>[
                              CreditCard(
                                color: "000000",
                                number: 9290,
                                image: "master.png",
                                valid: "VALID 10/22",
                              ),
                              CreditCard(
                                color: "000068",
                                number: 1298,
                                image: "visa.png",
                                valid: "VALID 07/24",
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildAddCardButton(
                        icon: Icon(Icons.add),
                        color: Color(0xFF081603),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
