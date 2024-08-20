import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/features/user/data/profile_local_data.dart';
import 'package:firebase_demo/features/user/model/chart_model.dart';
import 'package:firebase_demo/features/user/model/todo_model.dart';
import 'package:firebase_demo/features/auth/models/user_model.dart';
import 'package:firebase_demo/utils/theme/themedata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/notification_service.dart';

part '../state/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(
          HomeState(
            data: const [],
            count: 0,
            isChartDeleted: true,
            isLoading: false,
            upcomingTodos: [],
            newFriendRequestCount: 0,
            theme: lightTheme,
          ),
        ) {
    changeTheme();
    _isChartDeleted();
  }

  final LocalProfileCache _localCache = LocalProfileCache();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _listener;

  void changeTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final getTheme = prefs.getBool("themeData");
    if (getTheme != null) {
      switch (getTheme) {
        case false:
          emit(state.copyWith(theme: lightTheme));
          break;
        case true:
          emit(state.copyWith(theme: darkTheme));
          break;
      }
    } else {
      final brightness =
          SchedulerBinding.instance.platformDispatcher.platformBrightness;
      final isDarkMode = brightness == Brightness.dark;
      switch (isDarkMode) {
        case false:
          emit(state.copyWith(theme: lightTheme));
          break;
        case true:
          emit(state.copyWith(theme: darkTheme));
          break;
      }
    }
  }

  void cancelListener() async {
    await _listener?.cancel();
    _listener = null;
  }

  void _isChartDeleted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    emit(state.copyWith(isChartDeleted: prefs.getBool("isChartDeleted")));
  }

  void getChartData() async {
    final data = await ChartData.initChartData();

    emit(
      state.copyWith(data: data),
    );
  }

  void saveName(String name) async {
    _firestore
        .collection("User")
        .doc(_auth.currentUser!.uid)
        .update({"name": name});

    getChartData();
    countProfileData();

    await _auth.currentUser!.updateDisplayName(name);
  }

  void getUpcomingTodos() async {
    final currentUser = await _localCache.getDataFromFirebase();

    List<TodoModel> upcomingTodoList = [];
    final filteredList = currentUser.todoList?.where(
          (todo) => todo.isFinished == false,
        ) ??
        [];
    for (var todo in filteredList) {
      if (todo.endDate!.difference(DateTime.now()) < const Duration(days: 7)) {
        upcomingTodoList.add(todo);
      }
    }
    emit(state.copyWith(upcomingTodos: upcomingTodoList));
  }

  void getFriendRequestCount() async {
    final currentUser = await _localCache.getDataFromFirebase();
    emit(state.copyWith(
        newFriendRequestCount: currentUser.incomingFriendRequestList?.length));
  }

  void countProfileData() async {
    final UserModel currentUser = await _localCache.getDataFromFirebase();

    int count = 0;
    if (currentUser.name != null) count++;
    if (currentUser.surname != null) count++;
    if (currentUser.phoneNumber != null) count++;

    emit(state.copyWith(count: count));
  }

  void getNewMessageNotifiaction() async {
    var firstTime = true;

    final NotificationService service = NotificationService();
    _listener = _firestore
        .collection("User")
        .doc(_auth.currentUser!.uid)
        .collection("MessageFrom")
        .snapshots()
        .listen(
      (event) {
        if (firstTime) {
          firstTime = false;
          return;
        }
        for (var change in event.docChanges) {
          if (change.type == DocumentChangeType.added) {
            final lastMessageList = change.doc.data()!['messageFrom'];
            if (lastMessageList.isNotEmpty) {
              service.showNotification(
                title: "Yeni Mesaj",
                body: "asd",
              );
            }
          }
        }
      },
    );
  }

  //
  void logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isRemembered", false);

    _firestore.collection("User").doc(_auth.currentUser!.uid).update(
      {
        "isActive": false,
        "isRemembered": false,
      },
    );

    await _auth.signOut();
  }

  void deleteChartCard() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isChartDeleted", true);
    emit(state.copyWith(isChartDeleted: true));
  }

  void getTopUsers() async {
    final topUsers = await _firestore
        .collection("User")
        .where("points", isGreaterThan: -1)
        .get();
    final List<UserModel> topUserList = [];
    for (var document in topUsers.docs) {
      final user = UserModel.fromJson(document.data());
      topUserList.add(user);
    }

    final usersWithNames = topUserList
        .where(
          (user) => user.name != null,
        )
        .toList();

    List<dynamic> sortedTopUsers = List.filled(3, null);
    if (usersWithNames.length >= 3) {
      final sortedUsers = usersWithNames
        ..sublist(0, 3)
        ..sort(
          (a, b) => b.points.compareTo(a.points),
        )
        ..toList();

      emit(state.copyWith(
        firstUser: sortedUsers[0],
        secondUser: sortedUsers[1],
        thirdUser: sortedUsers[2],
        isLoading: true,
      ));
    } else if (usersWithNames.length < 3 && usersWithNames.isNotEmpty) {
      final sortedUsers = usersWithNames
        ..sort(
          (a, b) => b.points.compareTo(a.points),
        )
        ..toList();

      for (var i = 0; i < usersWithNames.length; i++) {
        sortedTopUsers[i] = sortedUsers[i];
      }

      emit(state.copyWith(
        firstUser: sortedTopUsers[0],
        secondUser: sortedTopUsers[1],
        thirdUser: sortedTopUsers[2],
      ));
    }
  }

  void getUserName() async {
    emit(state.copyWith(userName: _auth.currentUser!.displayName ?? ""));
  }

  bool isTextFieldChanged(String controllerText) {
    return controllerText.isNotEmpty;
  }
}
