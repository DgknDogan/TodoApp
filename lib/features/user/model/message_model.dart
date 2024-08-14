import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel extends Equatable {
  final String friendUserUid;
  final String text;
  final DateTime time;

  const MessageModel({
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

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  @override
  List<Object?> get props => [
        friendUserUid,
        text,
        time,
      ];
}
