part of '../cubit/profile_cubit.dart';

class ProfileState {
  final String name;
  final String surname;
  final String phoneNumber;
  final List<UserModel> friendReqList;
  final bool isFriendshipListLoading;

  ProfileState({
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.friendReqList,
    required this.isFriendshipListLoading,
  });

  ProfileState copyWith({
    String? name,
    String? surname,
    String? phoneNumber,
    List<UserModel>? friendReqList,
    bool? isFriendshipListLoading,
  }) {
    return ProfileState(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      friendReqList: friendReqList ?? this.friendReqList,
      isFriendshipListLoading:
          isFriendshipListLoading ?? this.isFriendshipListLoading,
    );
  }
}
