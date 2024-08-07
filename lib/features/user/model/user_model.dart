import 'package:firebase_demo/features/user/model/todo_model.dart';

class UserModel {
  final String? email;
  final String? name;
  final String? surname;
  final String? phoneNumber;
  final bool? isRemembered;
  final bool? isActive;

  List<TodoModel>? todoList = [];
  int points = 0;

  final List<dynamic>? incomingFriendRequestList;
  final List<dynamic>? sentFriendRequestList;
  final List<dynamic>? friendsList;

  UserModel({
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

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'surname': surname,
      'phoneNumber': phoneNumber,
      'todoList': todoList?.map((item) => item.toJson()).toList(),
      'isRemembered': isRemembered,
      'points': points,
      'friendsList': friendsList,
      'incomingFriendRequestList': incomingFriendRequestList,
      'sentFriendRequestList': sentFriendRequestList,
      'isActive': isActive,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] as String?,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      todoList: (json['todoList'] as List<dynamic>?)
          ?.map((item) => TodoModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      isRemembered: json['isRemembered'] as bool?,
      points: json['points'] as int,
      friendsList: (json['friendsList'] as List<dynamic>?),
      incomingFriendRequestList:
          (json['incomingFriendRequestList'] as List<dynamic>?),
      sentFriendRequestList: (json['sentFriendRequestList'] as List<dynamic>?),
      isActive: json['isActive'] as bool?,
    );
  }

  @override
  String toString() =>
      "UserModel(email: $email,name: $name,surname: $surname,phoneNumber: $phoneNumber)";

  @override
  int get hashCode => Object.hash(email, name, surname, phoneNumber);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          name == other.name &&
          surname == other.surname &&
          phoneNumber == other.phoneNumber;
}
