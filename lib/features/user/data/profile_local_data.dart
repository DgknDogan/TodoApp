import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/features/auth/models/user_model.dart';

class LocalProfileCache {
  UserModel? _cachedData;

  Future<UserModel> getDataFromFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    final currentUser = firestore.collection("User").doc(auth.currentUser!.uid);
    final currentUserDoc = await currentUser.get();
    dynamic json = currentUserDoc.data();
    _cachedData = UserModel.fromJson(json);

    return _cachedData!;
  }
}
