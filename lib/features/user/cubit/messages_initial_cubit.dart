import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/features/user/data/profile_local_data.dart';
import '../../auth/models/user_model.dart';

part '../state/messages_initial_state.dart';

class MessagesInitialCubit extends Cubit<MessagesInitialState> {
  MessagesInitialCubit() : super(MessagesInitialState(friendsList: [])) {
    fetchAllFriends();
  }

  final LocalProfileCache _localProfileCache = LocalProfileCache();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void fetchAllFriends() async {
    final currentUser = await _localProfileCache.getDataFromFirebase();

    final userCollection = await _firestore.collection("User").get();

    final List<String> userDocIdList = [];
    for (var userDoc in userCollection.docs) {
      userDocIdList.add(userDoc.id);
    }
    userDocIdList.remove(_auth.currentUser!.uid);

    final List<UserModel> freindList = [];
    for (var docId in userDocIdList) {
      if (currentUser.friendsList!.contains(docId)) {
        final userDoc = await _firestore.collection("User").doc(docId).get();
        final friend = UserModel.fromJson(userDoc.data()!);
        freindList.add(friend);
      }
    }

    emit(state.copyWith(
      friendsList: freindList,
    ));
  }
}
