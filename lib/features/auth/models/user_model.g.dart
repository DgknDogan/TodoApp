// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      points: (json['points'] as num).toInt(),
      isActive: json['isActive'] as bool?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      surname: json['surname'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      todoList: (json['todoList'] as List<dynamic>?)
          ?.map((e) => TodoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isRemembered: json['isRemembered'] as bool?,
      friendsList: json['friendsList'] as List<dynamic>?,
      incomingFriendRequestList:
          json['incomingFriendRequestList'] as List<dynamic>?,
      sentFriendRequestList: json['sentFriendRequestList'] as List<dynamic>?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'surname': instance.surname,
      'phoneNumber': instance.phoneNumber,
      'isRemembered': instance.isRemembered,
      'isActive': instance.isActive,
      'points': instance.points,
      'todoList': instance.todoList,
      'incomingFriendRequestList': instance.incomingFriendRequestList,
      'sentFriendRequestList': instance.sentFriendRequestList,
      'friendsList': instance.friendsList,
    };
