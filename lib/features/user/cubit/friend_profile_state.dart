part of 'friend_profile_cubit.dart';

class FriendProfileState {
  final bool? isFriendActive;
  final bool? isFriendWithUser;
  final String? friendUid;

  FriendProfileState({
    required this.isFriendActive,
    required this.isFriendWithUser,
    this.friendUid,
  });

  FriendProfileState copyWith({
    bool? isFriendActive,
    bool? isFriendWithUser,
    String? friendUid,
  }) {
    return FriendProfileState(
      isFriendActive: isFriendActive ?? this.isFriendActive,
      isFriendWithUser: isFriendWithUser ?? this.isFriendWithUser,
      friendUid: friendUid ?? this.friendUid,
    );
  }
}
