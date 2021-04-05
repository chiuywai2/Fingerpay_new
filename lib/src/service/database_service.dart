import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('user');

  Future updateUserData(double balance, String fullname, String phone) async {
    return await userCollection.doc(uid).set({
      'balance': balance,
      'fullname': fullname,
      'phone': phone,
    });
  }

  Future updatebalance(double balance) async {
    return await userCollection.doc(uid).set({
      'balance': balance,
    });
  }
}
