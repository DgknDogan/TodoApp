import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/features/user/model/message_model.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final ScrollController controller;
  final UserModel friend;
  MessageCubit({required this.friend, required this.controller})
      : super(
          MessageState(
            messagesList: [],
            isFriendActive: false,
          ),
        ) {
    _checkUserIsActive();
    listenChanges();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> _listener;
  late Timer _timer;

  @override
  Future<void> close() async {
    await _listener.cancel();
    _timer.cancel();
    return super.close();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _getFriendRef() async {
    final freindRef = await _firestore
        .collection("User")
        .where("name", isEqualTo: friend.name)
        .get();
    return freindRef;
  }

  void _checkUserIsActive() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (timer) => _isFriendActive(),
    );
  }

  void _isFriendActive() async {
    final friendQuerySnapshot = await _getFriendRef();
    final friendDoc = await _firestore
        .collection("User")
        .doc(friendQuerySnapshot.docs.first.id)
        .get();
    final friendData = friendDoc.data();
    final currentFriend = UserModel.fromJson(friendData!);
    emit(state.copyWith(isFriendActive: currentFriend.isActive));
  }

  void listenChanges() async {
    final searchedFriendRef = await _getFriendRef();

    _listener = _firestore
        .collection("User")
        .doc(_auth.currentUser!.uid)
        .collection("MessageFrom")
        .doc(searchedFriendRef.docs[0].id)
        .snapshots()
        .listen(
      (snapshot) {
        getMessagesFromUsers(friend);
      },
    );
  }

  void getMessagesFromUsers(UserModel friend) async {
    final searchedFriendRef = await _getFriendRef();

    final List<MessageModel> updatedMessageList = [];
    final messageFrom = _firestore
        .collection("User")
        .doc(_auth.currentUser!.uid)
        .collection("MessageFrom")
        .doc(searchedFriendRef.docs.first.id);

    final friendMessageFromDoc = await messageFrom.get();
    final friendMessageFromData = friendMessageFromDoc.data();
    final friendMessageFromList =
        (friendMessageFromData?["messageFrom"] as List<dynamic>)
            .map((item) => MessageModel.fromJson(item))
            .toList();
    final messageTo = _firestore
        .collection("User")
        .doc(_auth.currentUser!.uid)
        .collection("MessageTo")
        .doc(searchedFriendRef.docs.first.id);

    final currentUserMessageToDoc = await messageTo.get();
    final currentUserMessageToData = currentUserMessageToDoc.data();
    final currentUserMessageToList =
        (currentUserMessageToData?["messageTo"] as List<dynamic>)
            .map((item) => MessageModel.fromJson(item))
            .toList();

    updatedMessageList.addAll(friendMessageFromList);
    updatedMessageList.addAll(currentUserMessageToList);
    updatedMessageList.sort(
      (a, b) => a.time.compareTo(b.time),
    );

    if (controller.offset >= (controller.position.maxScrollExtent * 0.925)) {
      scrollToBottom();
    }
    emit(state.copyWith(messagesList: updatedMessageList));
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
      );
    });
  }

  void sendMessageToFriend(String text, UserModel friend) async {
    final searchedFriendRef = await _getFriendRef();

    final MessageModel newMessage = MessageModel(
      friendUserUid: _auth.currentUser!.uid,
      text: text,
      time: DateTime.now(),
    );

    final messageFrom = _firestore
        .collection("User")
        .doc(searchedFriendRef.docs.first.id)
        .collection("MessageFrom")
        .doc(_auth.currentUser!.uid);

    final friendMessageFromDoc = await messageFrom.get();
    final friendMessageFromData = friendMessageFromDoc.data();
    final friendMessageFromList =
        (friendMessageFromData?["messageFrom"] as List<dynamic>)
            .map((item) => MessageModel.fromJson(item))
            .toList();
    friendMessageFromList.add(newMessage);

    await messageFrom.set(
      {
        "messageFrom": friendMessageFromList.map((item) => item.toJson()),
      },
    );

    final messageTo = _firestore
        .collection("User")
        .doc(_auth.currentUser!.uid)
        .collection("MessageTo")
        .doc(searchedFriendRef.docs.first.id);

    final currentUserMessageToDoc = await messageTo.get();
    final currentUserMessageToData = currentUserMessageToDoc.data();
    final currentUserMessageToList =
        (currentUserMessageToData?["messageTo"] as List<dynamic>)
            .map((item) => MessageModel.fromJson(item))
            .toList();
    currentUserMessageToList.add(newMessage);

    await messageTo.update(
      {
        "messageTo": currentUserMessageToList.map((item) => item.toJson()),
      },
    );

    getMessagesFromUsers(friend);
  }

  void removeFromMe(MessageModel message) async {
    final friendQuerySnapshot = await _getFriendRef();

    final messageTo = _firestore
        .collection("User")
        .doc(_auth.currentUser!.uid)
        .collection("MessageTo")
        .doc(friendQuerySnapshot.docs.first.id);

    final messageFrom = _firestore
        .collection("User")
        .doc(_auth.currentUser!.uid)
        .collection("MessageFrom")
        .doc(friendQuerySnapshot.docs.first.id);

    final messageToDoc = await messageTo.get();
    final messageFromDoc = await messageFrom.get();

    final messageToList = (messageToDoc.data()!["messageTo"] as List)
        .map((item) => MessageModel.fromJson(item))
        .toList();
    final messageFromList = (messageFromDoc.data()!["messageFrom"] as List)
        .map((item) => MessageModel.fromJson(item))
        .toList();

    if (message.friendUserUid == _auth.currentUser!.uid) {
      messageToList.remove(message);

      await messageTo.update({
        "messageTo": messageToList.map((item) => item.toJson()).toList(),
      });
    } else {
      messageFromList.remove(message);

      await messageFrom.update({
        "messageFrom": messageFromList.map((item) => item.toJson()).toList(),
      });
    }
    getMessagesFromUsers(friend);
  }

  void removeFromEverybody(MessageModel message) async {
    final friendQuerySnapshot = await _getFriendRef();

    final currentMessageTo = _firestore
        .collection("User")
        .doc(_auth.currentUser!.uid)
        .collection("MessageTo")
        .doc(friendQuerySnapshot.docs.first.id);

    final currentMessageFrom = _firestore
        .collection("User")
        .doc(_auth.currentUser!.uid)
        .collection("MessageFrom")
        .doc(friendQuerySnapshot.docs.first.id);

    final friendMessageFrom = _firestore
        .collection("User")
        .doc(friendQuerySnapshot.docs.first.id)
        .collection("MessageFrom")
        .doc(_auth.currentUser!.uid);

    final friendMessageTo = _firestore
        .collection("User")
        .doc(friendQuerySnapshot.docs.first.id)
        .collection("MessageTo")
        .doc(_auth.currentUser!.uid);

    final messageToDoc = await currentMessageTo.get();
    final messageFromDoc = await friendMessageFrom.get();

    final messageToList = (messageToDoc.data()?["messageTo"] as List)
        .map((item) => MessageModel.fromJson(item))
        .toList();
    final messageFromList = (messageFromDoc.data()?["messageFrom"] as List)
        .map((item) => MessageModel.fromJson(item))
        .toList();

    if (messageToList.contains(message) || messageFromList.contains(message)) {
      removeFromMe(message);
      return;
    }
    messageToList.remove(message);
    messageFromList.remove(message);
    if (message.friendUserUid == _auth.currentUser!.uid) {
      await currentMessageTo.update({
        "messageTo": messageToList.map((item) => item.toJson()),
      });
      await friendMessageFrom.update({
        "messageFrom": messageFromList.map((item) => item.toJson()),
      });
    } else {
      await currentMessageFrom.update({
        "messageFrom": messageToList.map((item) => item.toJson()),
      });
      await friendMessageTo.update({
        "messageTo": messageFromList.map((item) => item.toJson()),
      });
    }
    getMessagesFromUsers(friend);
  }
}
