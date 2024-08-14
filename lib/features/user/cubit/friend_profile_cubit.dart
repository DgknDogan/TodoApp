import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/features/user/data/profile_local_data.dart';

import '../../auth/models/user_model.dart';

part '../state/friend_profile_state.dart';

class FriendProfileCubit extends Cubit<FriendProfileState> {
  final UserModel friend;
  FriendProfileCubit(this.friend)
      : super(
          FriendProfileState(
            isFriendActive: false,
            isFriendWithUser: false,
            isRequestSent: false,
          ),
        ) {
    _getSearchedFriendRef();
    _isFriendWithUser();
    _checkIsFriendshipRequestSent();
    listenFriendRequests();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalProfileCache _localCache = LocalProfileCache();
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _listener;

  void sendFriendshipRequest() async {
    final currentUser = await _localCache.getDataFromFirebase();

    if (currentUser.name == null) {
      return;
    }

    final sentUserDoc = _firestore.collection("User").doc(state.friendUid);
    final firendRef =
        await _firestore.collection("User").doc(state.friendUid).get();
    final currentFriend = UserModel.fromJson(firendRef.data()!);

    currentFriend.incomingFriendRequestList?.add(_auth.currentUser!.uid);
    await sentUserDoc.update(
      {"incomingFriendRequestList": currentFriend.incomingFriendRequestList},
    );

    currentUser.sentFriendRequestList?.add(state.friendUid);
    final currentUserDoc =
        _firestore.collection("User").doc(_auth.currentUser!.uid);
    await currentUserDoc.update(
      {"sentFriendRequestList": currentUser.sentFriendRequestList},
    );
  }

  void cancelFriendshipRequest() async {
    final currentUser = await _localCache.getDataFromFirebase();

    final sentUserDoc = _firestore.collection("User").doc(state.friendUid);
    final firendRef =
        await _firestore.collection("User").doc(state.friendUid).get();
    final currentFriend = UserModel.fromJson(firendRef.data()!);

    currentFriend.incomingFriendRequestList?.remove(_auth.currentUser!.uid);
    await sentUserDoc.update(
      {"incomingFriendRequestList": currentFriend.incomingFriendRequestList},
    );

    currentUser.sentFriendRequestList?.remove(state.friendUid);
    final currentUserDoc =
        _firestore.collection("User").doc(_auth.currentUser!.uid);
    await currentUserDoc.update(
      {"sentFriendRequestList": currentUser.sentFriendRequestList},
    );
  }

  void _checkIsFriendshipRequestSent() async {
    final firendRef = await _firestore
        .collection("User")
        .where("name", isEqualTo: friend.name)
        .get();
    final currentFriend = UserModel.fromJson(firendRef.docs.first.data());
    emit(
      state.copyWith(
        isRequestSent: currentFriend.incomingFriendRequestList!
            .contains(_auth.currentUser!.uid),
      ),
    );
  }

  void removeFriend() async {
    final currentUser = await _localCache.getDataFromFirebase();

    final sentUserDoc = _firestore.collection("User").doc(state.friendUid);

    friend.friendsList!.remove(_auth.currentUser!.uid);
    await sentUserDoc.update(
      {"friendsList": friend.friendsList},
    );

    currentUser.friendsList!.remove(state.friendUid);
    final currentUserDoc =
        _firestore.collection("User").doc(_auth.currentUser!.uid);
    await currentUserDoc.update(
      {"friendsList": currentUser.friendsList},
    );
  }

  void _getSearchedFriendRef() async {
    final friendQuerySnapshot = await _firestore
        .collection("User")
        .where("name", isEqualTo: friend.name)
        .get();

    emit(
      state.copyWith(
        friendUid: friendQuerySnapshot.docs.first.id,
      ),
    );
  }

  void _isFriendWithUser() async {
    final firendRef = await _firestore
        .collection("User")
        .where("name", isEqualTo: friend.name)
        .get();
    final currentFriend = UserModel.fromJson(firendRef.docs.first.data());
    emit(
      state.copyWith(
        isFriendWithUser:
            currentFriend.friendsList?.contains(_auth.currentUser!.uid),
      ),
    );
  }

  void cancelListener() async {
    await _listener?.cancel();
    _listener = null;
  }

  void listenFriendRequests() {
    _listener = _firestore
        .collection("User")
        .doc(_auth.currentUser!.uid)
        .snapshots()
        .listen(
      (event) {
        _checkIsFriendshipRequestSent();
        _isFriendWithUser();
      },
    );
  }
}
