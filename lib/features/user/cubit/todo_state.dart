part of 'todo_cubit.dart';

final class TodoState {
  final List<TodoModel> todoList;
  final List<TodoModel> finishedTodoList;
  final dynamic dropdownValue;

  final UserModel? currentUser;
  final PriorityEnum? priority;
  final TodoCategoryEnum? category;
  final DateTime? day;
  final TimeOfDay? time;
  final String? title;

  TodoState({
    required this.dropdownValue,
    required this.todoList,
    required this.finishedTodoList,
    this.currentUser,
    this.priority,
    this.category,
    this.day,
    this.time,
    this.title,
  });

  TodoState copyWith({
    List<TodoModel>? todoList,
    List<TodoModel>? finishedTodoList,
    PriorityEnum? priority,
    TodoCategoryEnum? category,
    DateTime? day,
    TimeOfDay? time,
    String? title,
    dynamic dropdownValue,
    UserModel? currentUser,
  }) {
    return TodoState(
      todoList: todoList ?? this.todoList,
      category: category ?? this.category,
      day: day ?? this.day,
      priority: priority ?? this.priority,
      time: time ?? this.time,
      title: title ?? this.title,
      dropdownValue: dropdownValue ?? this.dropdownValue,
      currentUser: currentUser ?? this.currentUser,
      finishedTodoList: finishedTodoList ?? this.finishedTodoList,
    );
  }
}
