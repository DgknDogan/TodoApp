import 'package:equatable/equatable.dart';
import 'package:firebase_demo/features/user/model/todo_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String? email;
  final String? name;
  final String? surname;
  final String? phoneNumber;
  final bool? isRemembered;
  final bool? isActive;

  final int points;
  final List<TodoModel>? todoList;
  final List<dynamic>? incomingFriendRequestList;
  final List<dynamic>? sentFriendRequestList;
  final List<dynamic>? friendsList;

  const UserModel({
    required this.points,
    this.isActive,
    this.email,
    this.name,
    this.surname,
    this.phoneNumber,
    this.todoList,
    this.isRemembered,
    this.friendsList,
    this.incomingFriendRequestList,
    this.sentFriendRequestList,
  });

  UserModel copyWith({
    String? email,
    String? name,
    String? surname,
    String? phoneNumber,
    bool? isRemembered,
    bool? isActive,
    List<TodoModel>? todoList,
    int? points,
    List<dynamic>? incomingFriendRequestList,
    List<dynamic>? sentFriendRequestList,
    List<dynamic>? friendsList,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      todoList: todoList ?? this.todoList,
      isRemembered: isRemembered ?? this.isRemembered,
      points: points ?? this.points,
      friendsList: friendsList ?? this.friendsList,
      incomingFriendRequestList:
          incomingFriendRequestList ?? this.incomingFriendRequestList,
      sentFriendRequestList:
          sentFriendRequestList ?? this.sentFriendRequestList,
      isActive: isActive ?? this.isActive,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  @override
  List<Object?> get props => [
        points,
        isActive,
        email,
        name,
        surname,
        phoneNumber,
        todoList,
        isRemembered,
        friendsList,
        incomingFriendRequestList,
        sentFriendRequestList,
      ];
}
