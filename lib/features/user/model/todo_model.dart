import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_demo/features/user/data/enums/todo_category_enum.dart';
import '../data/enums/priority_enum.dart';

class TodoModel {
  String? title;
  TodoCategoryEnum? category;
  PriorityEnum? priority;
  bool? isFinished;
  DateTime? startDate;
  DateTime? endDate;

  TodoModel({
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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category?.text,
      'priority': priority?.value,
      'isFinished': isFinished,
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      title: json['title'] as String?,
      category: TodoCategoryEnum.getCategoryByText(json['category'])
          as TodoCategoryEnum?,
      isFinished: json['isFinished'] as bool?,
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      priority:
          PriorityEnum.getPriorityByValue(json['priority']) as PriorityEnum?,
    );
  }

  @override
  String toString() =>
      "TodoModel(title: $title,category: $category,isFinished: $isFinished,startDate: $startDate,endDate: $endDate)";

  @override
  int get hashCode =>
      Object.hash(title, category, isFinished, startDate, endDate);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodoModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          category == other.category &&
          isFinished == other.isFinished &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          priority == other.priority;
}
