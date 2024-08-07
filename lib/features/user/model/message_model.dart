import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String friendUserUid;
  final String text;
  final DateTime time;

  MessageModel({
    required this.friendUserUid,
    required this.text,
    required this.time,
  });

  MessageModel copyWith({
    String? friendUserUid,
    String? text,
    DateTime? time,
  }) {
    return MessageModel(
      friendUserUid: friendUserUid ?? this.friendUserUid,
      text: text ?? this.text,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'friendUserUid': friendUserUid,
      'text': text,
      'time': time,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      friendUserUid: json['friendUserUid'] as String,
      text: json['text'] as String,
      time: (json['time'] as Timestamp).toDate(),
    );
  }

  @override
  int get hashCode => Object.hash(friendUserUid, text, time);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageModel &&
          runtimeType == other.runtimeType &&
          friendUserUid == other.friendUserUid &&
          text == other.text &&
          time == other.time;
}
