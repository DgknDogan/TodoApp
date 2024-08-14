part of '../cubit/messages_initial_cubit.dart';

class MessagesInitialState {
  final List<UserModel> friendsList;

  MessagesInitialState({required this.friendsList});

  MessagesInitialState copyWith({List<UserModel>? friendsList}) {
    return MessagesInitialState(
      friendsList: friendsList ?? this.friendsList,
    );
  }
}
