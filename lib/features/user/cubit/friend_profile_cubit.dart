import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/features/user/data/profile_local_data.dart';

import '../model/user_model.dart';

part 'friend_profile_state.dart';

class FriendProfileCubit extends Cubit<FriendProfileState> {
  final UserModel friend;
  FriendProfileCubit(this.friend)
      : super(
          FriendProfileState(
            isFriendActive: false,
            isFriendWithUser: false,
          ),
        ) {
    _getSearchedFriendRef();
    _isFriendWithUser();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final LocalProfileCache _localCache = LocalProfileCache();

  void sendFriendshipRequest() async {
    final currentUser = await _localCache.getDataFromFirebase();

    final sentUserDoc = _firestore.collection("User").doc(state.friendUid);

    friend.incomingFriendRequestList?.add(_auth.currentUser!.uid);
    await sentUserDoc.update(
      {"incomingFriendRequestList": friend.incomingFriendRequestList},
    );

    currentUser.sentFriendRequestList?.add(state.friendUid);
    final currentUserDoc =
        _firestore.collection("User").doc(_auth.currentUser!.uid);
    await currentUserDoc.update(
      {"sentFriendRequestList": currentUser.sentFriendRequestList},
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

  void _isFriendWithUser() {
    emit(
      state.copyWith(
        isFriendWithUser: friend.friendsList?.contains(_auth.currentUser!.uid),
      ),
    );
  }
}
