import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../../user/cubit/home_cubit.dart';
import '../../user/data/profile_local_data.dart';
import '../../user/model/user_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final HomeCubit homeCubit;
  ProfileCubit({required this.homeCubit})
      : super(
          ProfileState(
            name: "",
            surname: "",
            phoneNumber: "",
            friendReqList: [],
          ),
        ) {
    getDataFromCache();
    getFriendRequestList();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void saveName(String name) async {
    _firestore
        .collection("User")
        .doc(_auth.currentUser!.uid)
        .update({"name": name});

    homeCubit.initializeChartData();
    homeCubit.countProfileData();

    _auth.currentUser!.updateDisplayName(name);

    emit(state.copyWith(name: name));
  }

  void saveSurname(String surname) async {
    _firestore
        .collection("User")
        .doc(_auth.currentUser!.uid)
        .update({"surname": surname});

    homeCubit.initializeChartData();
    homeCubit.countProfileData();

    emit(state.copyWith(surname: surname));
  }

  void savePhoneNumber(String phoneNumber) async {
    _firestore
        .collection("User")
        .doc(_auth.currentUser!.uid)
        .update({"phoneNumber": phoneNumber});

    homeCubit.initializeChartData();
    homeCubit.countProfileData();

    emit(state.copyWith(phoneNumber: phoneNumber));
  }

  void getDataFromCache() async {
    final currentUser = await LocalProfileCache().getDataFromFirebase();
    String name = currentUser.name ?? "";
    String surname = currentUser.surname ?? "";
    String phoneNumber = currentUser.phoneNumber ?? "";
    emit(state.copyWith(
      name: name,
      phoneNumber: phoneNumber,
      surname: surname,
    ));
  }

  bool isTextFieldChanged(TextEditingController controller, String text) {
    return controller.text != text && controller.text.isNotEmpty;
  }

  void getFriendRequestList() async {
    final currentUser = await LocalProfileCache().getDataFromFirebase();
    final List<UserModel> friendReqList = [];
    for (var userUid in currentUser.incomingFriendRequestList ?? []) {
      final friendRef = await _firestore.collection("User").doc(userUid).get();
      final friendData = friendRef.data();
      friendReqList.add(UserModel.fromJson(friendData!));
    }
    emit(state.copyWith(friendReqList: friendReqList));
    homeCubit.getFriendRequestCount();
  }

  void acceptFriendship(String name) async {
    final currentUser = await LocalProfileCache().getDataFromFirebase();
    final list = List.from(currentUser.incomingFriendRequestList!.toList());
    for (var userUid in list) {
      final acceptedFriendDoc = _firestore.collection("User").doc(userUid);
      final acceptedFriendRef = await acceptedFriendDoc.get();
      final acceptedFriendData = acceptedFriendRef.data();
      final acceptedFriend = UserModel.fromJson(acceptedFriendData!);
      if (acceptedFriend.name == name) {
        currentUser.friendsList?.add(userUid);
        currentUser.incomingFriendRequestList?.remove(userUid);
        await _firestore.collection("User").doc(_auth.currentUser!.uid).update(
          {
            "friendsList": currentUser.friendsList,
            "incomingFriendRequestList": currentUser.incomingFriendRequestList,
          },
        );
        acceptedFriend.sentFriendRequestList?.remove(_auth.currentUser!.uid);
        acceptedFriend.friendsList?.add(_auth.currentUser!.uid);
        acceptedFriendDoc.update({
          "friendsList": acceptedFriend.friendsList,
          "sentFriendRequestList": acceptedFriend.sentFriendRequestList,
        });
      }
    }
    getFriendRequestList();
    homeCubit.getFriendRequestCount();
  }

  void denyFriendship(String name) async {
    final currentUser = await LocalProfileCache().getDataFromFirebase();
    final list = List.from(currentUser.incomingFriendRequestList!.toList());
    for (var userUid in list) {
      final acceptedFriendDoc = _firestore.collection("User").doc(userUid);
      final acceptedFriendRef = await acceptedFriendDoc.get();
      final acceptedFriendData = acceptedFriendRef.data();
      final acceptedFriend = UserModel.fromJson(acceptedFriendData!);
      if (acceptedFriend.name == name) {
        currentUser.incomingFriendRequestList?.remove(userUid);
        await _firestore.collection("User").doc(_auth.currentUser!.uid).update(
          {
            "incomingFriendRequestList": currentUser.incomingFriendRequestList,
          },
        );
        acceptedFriend.sentFriendRequestList?.remove(_auth.currentUser!.uid);
        acceptedFriendDoc.update({
          "sentFriendRequestList": acceptedFriend.sentFriendRequestList,
        });
      }
    }
    getFriendRequestList();
    homeCubit.getFriendRequestCount();
  }
}
