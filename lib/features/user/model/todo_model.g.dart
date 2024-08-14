// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoModel _$TodoModelFromJson(Map<String, dynamic> json) => TodoModel(
      title: json['title'] as String?,
      category:
          $enumDecodeNullable(_$TodoCategoryEnumEnumMap, json['category']),
      isFinished: json['isFinished'] as bool?,
      startDate: json['startDate'] == null
          ? null
          : (json['startDate'] as Timestamp).toDate(),
      endDate: json['endDate'] == null
          ? null
          : (json['endDate'] as Timestamp).toDate(),
      priority: $enumDecodeNullable(_$PriorityEnumEnumMap, json['priority']),
    );

Map<String, dynamic> _$TodoModelToJson(TodoModel instance) => <String, dynamic>{
      'title': instance.title,
      'category': _$TodoCategoryEnumEnumMap[instance.category],
      'priority': _$PriorityEnumEnumMap[instance.priority],
      'isFinished': instance.isFinished,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
    };

const _$TodoCategoryEnumEnumMap = {
  TodoCategoryEnum.work: 'Work',
  TodoCategoryEnum.home: 'Home',
  TodoCategoryEnum.university: 'University',
};

const _$PriorityEnumEnumMap = {
  PriorityEnum.low: 1,
  PriorityEnum.mid: 2,
  PriorityEnum.high: 3,
};
