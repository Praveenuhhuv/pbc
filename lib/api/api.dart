import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;

class APIs {
  // for authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  //accessing cloud storage database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

//to return current user
  static User get user => auth.currentUser!;
  //for gt current user exit or not
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }
}
