import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/features/user/data/profile_local_data.dart';
import 'package:firebase_demo/features/user/model/chart_model.dart';
import 'package:firebase_demo/features/user/model/todo_model.dart';
import 'package:firebase_demo/features/user/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/notification_service.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit()
      : super(
          HomeState(
            data: const [],
            count: 0,
            isChartDeleted: true,
            upcomingTodos: [],
            newFriendRequestCount: 0,
          ),
        ) {
    getTopUsers();
    _isChartDeleted();
    initializeChartData();
    getUpcomingTodos();
    getFriendRequestCount();
    countProfileData();
    getNewMessageNotifiaction();
  }

  final LocalProfileCache _localCache = LocalProfileCache();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>> _listener;

  @override
  Future<void> close() async {
    await _listener.cancel();
    return super.close();
  }

  void _isChartDeleted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    emit(state.copyWith(isChartDeleted: prefs.getBool("isChartDeleted")));
  }

  void initializeChartData() async {
    final UserModel currentUser = await _localCache.getDataFromFirebase();
    const Color redColor = Color(0xffEF3726);
    const Color greenColor = Color(0xff00D23C);

    final data = [
      ChartData(
        x: 'Phone Number',
        y: 1,
        color: currentUser.phoneNumber == null ? redColor : greenColor,
      ),
      ChartData(
        x: 'Name',
        y: 1,
        color: currentUser.name == null ? redColor : greenColor,
      ),
      ChartData(
        x: 'Surname',
        y: 1,
        color: currentUser.surname == null ? redColor : greenColor,
      ),
    ];

    emit(
      state.copyWith(data: data),
    );
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
        log(event.docChanges.length.toString());
        final lastMessage =
            (event.docChanges.last.doc.data()!['messageFrom'] as List).last;
        service.showNotification(
          title: "Yeni Mesaj",
          body: lastMessage['text'],
        );
      },
    );
  }

  //
  void logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await FirebaseAuth.instance.signOut();
    prefs.setBool("isRemembered", false);
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

    final sortedTopUsers = topUserList
        .where(
          (user) => user.name != null,
        )
        .toList()
      ..sublist(0, 3)
      ..sort(
        (a, b) => b.points.compareTo(a.points),
      )
      ..toList();

    emit(state.copyWith(
      firstUser: sortedTopUsers[0],
      secondUser: sortedTopUsers[1],
      thirdUser: sortedTopUsers[2],
    ));
  }

  void getUserName() async {
    emit(state.copyWith(userName: _auth.currentUser!.displayName ?? ""));
  }
}
