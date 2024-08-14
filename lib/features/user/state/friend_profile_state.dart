part of '../cubit/friend_profile_cubit.dart';

class FriendProfileState {
  final bool? isFriendActive;
  final bool? isFriendWithUser;
  final bool isRequestSent;
  final String? friendUid;

  FriendProfileState({
    required this.isFriendActive,
    required this.isFriendWithUser,
    required this.isRequestSent,
    this.friendUid,
  });

  FriendProfileState copyWith({
    bool? isFriendActive,
    bool? isFriendWithUser,
    bool? isRequestSent,
    String? friendUid,
  }) {
    return FriendProfileState(
      isFriendActive: isFriendActive ?? this.isFriendActive,
      isFriendWithUser: isFriendWithUser ?? this.isFriendWithUser,
      friendUid: friendUid ?? this.friendUid,
      isRequestSent: isRequestSent ?? this.isRequestSent,
    );
  }
}
