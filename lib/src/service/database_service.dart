import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

  Future updateUserName(String fullname) async {
    return await userCollection.doc(uid).update({
      'fullname': fullname,
    });
  }

  Future updateUserPhone(String phone) async {
    return await userCollection.doc(uid).update({
      'phone': phone,
    });
  }

  Future updatebalance(double balance) async {
    return await userCollection.doc(uid).update({
      'balance': balance,
    });
  }

  Future transactionRecord(
      String partnerUid, double amount, DateTime now, bool pay) async {
    if (pay) {
      await userCollection
          .doc(uid)
          .collection('transaction')
          .doc(DateFormat('yyyyMMddHHmm').format(now))
          .set({
        'amount': amount,
        'partner': partnerUid,
        'Time': now,
      });
      await userCollection
          .doc(partnerUid)
          .collection('transaction')
          .doc(DateFormat('yyyyMMddHHmm').format(now))
          .set({
        'amount': -amount,
        'partner': uid,
        'Time': now,
      });
    } else {
      await userCollection
          .doc(uid)
          .collection('transaction')
          .doc(DateFormat('yyyyMMddHHmm').format(now))
          .set({
        'amount': -amount,
        'partner': partnerUid,
        'Time': now,
      });
      await userCollection
          .doc(partnerUid)
          .collection('transaction')
          .doc(DateFormat('yyyyMMddHHmm').format(now))
          .set({
        'amount': amount,
        'partner': uid,
        'Time': now,
      });
    }
  }

  // Future<String> getUserName(String uid) async {
  //   final user = await FirebaseAdmin.instance.app().auth().getUser(uid);
  //   final name = user.displayName;
  //   return name;
  // }
  //
  Future<String> getUserName(String _uid) async {
    String name;
    await userCollection.doc(_uid).get().then((snapshot) {
      name = snapshot.data()['fullname'].toString();
    });
    return name;
  }

  // Future<String> getIconpath(String uid) async {
  //   final user = await FirebaseAdmin.instance.app().auth().getUser(uid);
  //   final iconPath = user.photoUrl;
  //   return iconPath;
  // }
}
