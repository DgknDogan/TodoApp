part of 'profile_cubit.dart';

class ProfileState {
  final String name;
  final String surname;
  final String phoneNumber;
  final List<UserModel> friendReqList;

  ProfileState({
    required this.name,
    required this.surname,
    required this.phoneNumber,
    required this.friendReqList,
  });

  ProfileState copyWith({
    String? name,
    String? surname,
    String? phoneNumber,
    List<UserModel>? friendReqList,
  }) {
    return ProfileState(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      friendReqList: friendReqList ?? this.friendReqList,
    );
  }
}
