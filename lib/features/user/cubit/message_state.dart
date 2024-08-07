part of 'message_cubit.dart';

class MessageState {
  final List<MessageModel> messagesList;
  final bool? isFriendActive;

  MessageState({
    required this.messagesList,
    required this.isFriendActive,
  });

  MessageState copyWith(
      {List<MessageModel>? messagesList, bool? isFriendActive}) {
    return MessageState(
      messagesList: messagesList ?? this.messagesList,
      isFriendActive: isFriendActive ?? this.isFriendActive,
    );
  }
}
