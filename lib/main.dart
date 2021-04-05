import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fingerpay/src/screen/home.dart';
import 'package:fingerpay/src/screen/welcome.dart';
import 'package:fingerpay/src/service/auth_service.dart';
import 'package:fingerpay/src/widget/provider_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Provider(
        auth: AuthService(),
        db: FirebaseFirestore.instance,
        child: MaterialApp(
          title: 'Finger Pay System',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
                bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
              )),
          debugShowCheckedModeBanner: false,
          home: LandingPage(),
          routes: <String, WidgetBuilder>{
            '/home': (BuildContext context) => HomePage(),
          },
        ));
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? HomePage() : WelcomePage();
        }
        return CircularProgressIndicator();
      },
    );
  }
}
