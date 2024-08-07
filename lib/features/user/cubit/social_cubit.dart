import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/features/user/model/user_model.dart';

part 'social_state.dart';

class FriendCubit extends Cubit<SocialState> {
  FriendCubit()
      : super(
          SocialState(
            suggestedList: [],
          ),
        );

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void updateSuggestedList(String name) async {
    final users =
        await _firestore.collection("User").where("name", isNull: false).get();

    final List<UserModel> usersList = [];
    for (var userDocument in users.docs) {
      final user = UserModel.fromJson(userDocument.data());
      usersList.add(user);
    }

    final List<UserModel> suggestedList = [];
    for (var user in usersList) {
      if (user.name!.contains(name)) {
        suggestedList.add(user);
      }
    }

    suggestedList.removeWhere(
      (element) => element.name == _auth.currentUser!.displayName,
    );
    emit(SocialState(suggestedList: suggestedList));
  }

  Future<List<UserModel>> getSuggestedList(String search) async {
    if (search.isEmpty) {
      return [];
    }
    final users =
        await _firestore.collection("User").where("name", isNull: false).get();

    final List<UserModel> usersList = [];
    for (var userDocument in users.docs) {
      final user = UserModel.fromJson(userDocument.data());
      usersList.add(user);
    }

    final List<UserModel> suggestedList = [];
    for (var user in usersList) {
      if (user.name!.contains(search)) {
        suggestedList.add(user);
      }
    }

    suggestedList.removeWhere(
      (element) => element.name == _auth.currentUser!.displayName,
    );
    return suggestedList;
  }
}
