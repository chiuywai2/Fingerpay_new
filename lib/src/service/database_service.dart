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

  Future updatebalance(double balance) async {
    return await userCollection.doc(uid).update({
      'balance': balance,
    });
  }

  Future transactionRecord(String partnerUid, String partnerName,
      String selfName, double amount, DateTime now, bool pay) async {
    if (pay) {
      await userCollection
          .doc(uid)
          .collection('transaction')
          .doc(DateFormat('yyyyMMddHHmm').format(now))
          .set({
        'amount': amount,
        'partner': partnerName,
        'Time': now,
      });
      await userCollection
          .doc(partnerUid)
          .collection('transaction')
          .doc(DateFormat('yyyyMMddHHmm').format(now))
          .set({
        'amount': -amount,
        'partner': selfName,
        'Time': now,
      });
    } else {
      await userCollection
          .doc(uid)
          .collection('transaction')
          .doc(now.year.toString() +
              now.month.toString() +
              now.day.toString() +
              now.hour.toString() +
              now.minute.toString() +
              now.second.toString())
          .set({
        'amount': -amount,
        'partner': partnerName,
        'Time': now,
      });
      await userCollection
          .doc(partnerUid)
          .collection('transaction')
          .doc(now.year.toString() +
              now.month.toString() +
              now.day.toString() +
              now.hour.toString() +
              now.minute.toString() +
              now.second.toString())
          .set({
        'amount': amount,
        'partner': selfName,
        'Time': now,
      });
    }
  }
}
