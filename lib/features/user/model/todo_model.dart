import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_demo/features/user/model/enum/todo_category_enum.dart';
import 'package:json_annotation/json_annotation.dart';
import 'enum/priority_enum.dart';

part 'todo_model.g.dart';

DateTime? dateTimeFromTimestamp(Timestamp timestamp) {
  return timestamp.toDate();
}

@JsonSerializable()
class TodoModel extends Equatable {
  final String? title;
  final TodoCategoryEnum? category;
  final PriorityEnum? priority;
  final bool? isFinished;
  // @JsonKey(fromJson: dateTimeFromTimestamp)
  final DateTime? startDate;
  // @JsonKey(fromJson: dateTimeFromTimestamp)
  final DateTime? endDate;

  const TodoModel({
    this.title,
    this.category,
    this.isFinished,
    this.startDate,
    this.endDate,
    this.priority,
  });

  TodoModel copyWith({
    String? title,
    TodoCategoryEnum? category,
    PriorityEnum? priority,
    bool? isFinished,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return TodoModel(
      title: title ?? this.title,
      category: category ?? this.category,
      isFinished: isFinished ?? this.isFinished,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      priority: priority ?? this.priority,
    );
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodoModelToJson(this);

  @override
  List<Object?> get props => [
        title,
        category,
        isFinished,
        startDate,
        endDate,
        priority,
      ];
}
