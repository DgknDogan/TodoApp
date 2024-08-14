import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/features/user/cubit/home_cubit.dart';
import 'package:firebase_demo/features/user/model/enum/todo_category_enum.dart';
import 'package:firebase_demo/features/user/data/profile_local_data.dart';
import 'package:firebase_demo/features/user/model/todo_model.dart';
import 'package:firebase_demo/features/auth/models/user_model.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../model/enum/priority_enum.dart';

part '../state/todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final HomeCubit homeCubit;
  TodoCubit({required this.homeCubit})
      : super(
          TodoState(
            todoList: const [],
            finishedTodoList: [],
            dropdownValue: null,
          ),
        ) {
    fetchTodos();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalProfileCache _localCache = LocalProfileCache();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Todo methods
  void addNewTodo({required Function getUpcomingTodos}) async {
    TodoModel newTodo = TodoModel(
      title: state.title,
      category: state.category,
      priority: state.priority,
      isFinished: false,
      startDate: DateTime.now(),
      endDate: state.day!.copyWith(
        hour: state.time?.hour,
        minute: state.time?.minute,
      ),
    );
    fetchTodos();

    final currentUser = await _localCache.getDataFromFirebase();
    final updatedTodos = List<TodoModel>.from(state.todoList)..add(newTodo);

    List<Map<String, dynamic>> mappedTodos = [];
    for (var todo in updatedTodos) {
      mappedTodos.add(todo.toJson());
    }
    _firestore.collection("User").doc(_auth.currentUser!.uid).update(
      {
        "points": currentUser.points + newTodoPoints,
        "todoList": mappedTodos,
      },
    );
    if (state.dropdownValue != null) {
      sortByValue(state.dropdownValue);
    }
    getUpcomingTodos();
    fetchTodos();
  }

  void finishTodo(TodoModel currentTodo) async {
    final currentUser = await _localCache.getDataFromFirebase();

    final updatedTodos = List<TodoModel>.from(
      currentUser.todoList?.where(
            (todo) => todo.isFinished == false,
          ) ??
          [],
    );

    updatedTodos.remove(currentTodo);

    final updatedFinishedTodos = List<TodoModel>.from(state.finishedTodoList);
    updatedFinishedTodos.add(currentTodo.copyWith(isFinished: true));

    List<Map<String, dynamic>> mappedTodos = [];
    final totalList = [];
    totalList.addAll(updatedTodos);
    totalList.addAll(updatedFinishedTodos);
    for (var todo in totalList) {
      mappedTodos.add(todo.toJson());
    }

    await _firestore.collection("User").doc(_auth.currentUser!.uid).update(
      {
        "points": currentUser.points + finishedTodoPoints,
        "todoList": mappedTodos,
      },
    );
    homeCubit.getUpcomingTodos();
    emit(state.copyWith(
      todoList: updatedTodos,
      finishedTodoList: updatedFinishedTodos,
    ));

    if (state.dropdownValue != null) {
      sortByValue(state.dropdownValue);
    }
  }

  void unfinishTodo(TodoModel currentTodo) async {
    final currentUser = await _localCache.getDataFromFirebase();

    final updatedTodos = List<TodoModel>.from(currentUser.todoList?.where(
          (todo) => todo.isFinished == false,
        ) ??
        []);
    final updatedFinishedTodos = List<TodoModel>.from(state.finishedTodoList);

    updatedFinishedTodos.remove(currentTodo);
    updatedTodos.add(currentTodo.copyWith(isFinished: false));

    List<Map<String, dynamic>> mappedTodos = [];
    final totalList = [];
    totalList.addAll(updatedTodos);
    totalList.addAll(updatedFinishedTodos);
    for (var todo in totalList) {
      mappedTodos.add(todo.toJson());
    }

    await _firestore.collection("User").doc(_auth.currentUser!.uid).update(
      {
        "points": currentUser.points - finishedTodoPoints,
        "todoList": mappedTodos,
      },
    );
    homeCubit.getUpcomingTodos();
    emit(state.copyWith(
      todoList: updatedTodos,
      finishedTodoList: updatedFinishedTodos,
    ));
    if (state.dropdownValue != null) {
      sortByValue(state.dropdownValue);
    }
  }

  void fetchTodos() async {
    final currentUser = await _localCache.getDataFromFirebase();

    final updatedTodos = List<TodoModel>.from(currentUser.todoList?.where(
          (todo) => todo.isFinished == false,
        ) ??
        []);
    final updatedFinishedTodos = List<TodoModel>.from(
      currentUser.todoList?.where(
            (todo) => todo.isFinished == true,
          ) ??
          [],
    );
    emit(
      state.copyWith(
        todoList: updatedTodos,
        finishedTodoList: updatedFinishedTodos,
      ),
    );
  }

  void deleteTodo({
    required TodoModel currentTodo,
    required Function function,
  }) async {
    final currentUser = await _localCache.getDataFromFirebase();

    final updatedTodos = List<TodoModel>.from(currentUser.todoList ?? []);
    final updatedFinishedTodos = List<TodoModel>.from(state.finishedTodoList);

    updatedTodos.remove(currentTodo);
    updatedFinishedTodos.remove(currentTodo);

    List<Map<String, dynamic>> mappedTodos = [];
    final totalList = [];
    totalList.addAll(updatedTodos);
    totalList.addAll(updatedFinishedTodos);
    for (var todo in totalList) {
      mappedTodos.add(todo.toJson());
    }

    _firestore.collection("User").doc(_auth.currentUser!.uid).update(
      {
        "todoList": mappedTodos,
      },
    );

    if (state.dropdownValue != null) {
      sortByValue(state.dropdownValue);
    }

    function();
    fetchTodos();
  }

  bool isAbleToAddNewTodo() {
    return (state.time != null) &&
        (state.title != null) &&
        (state.day != null) &&
        (state.category != null) &&
        (state.priority != null);
  }
  //

  // DropDown methods
  void changeDropDown(dynamic value) {
    emit(state.copyWith(dropdownValue: value));
  }

  void sortByValue(int value) {
    if (value == 1) {
      sortByFinishTime();
    } else if (value == 2) {
      sortByPriority();
    }
  }

  /// Sorts the list from closest date to futhest date
  void sortByFinishTime() async {
    final updatedTodos = List<TodoModel>.from(state.todoList);
    updatedTodos.sort((a, b) {
      return a.endDate!.compareTo(b.endDate!);
    });
    emit(state.copyWith(todoList: updatedTodos, dropdownValue: 1));
  }

  /// Sorts the list from the most important to least important
  void sortByPriority() async {
    final updatedTodos = List<TodoModel>.from(state.todoList);

    updatedTodos.sort((a, b) {
      return b.priority!.value.compareTo(a.priority!.value);
    });
    emit(state.copyWith(todoList: updatedTodos, dropdownValue: 2));
  }
  //

  // Setter methods
  void setPriority(PriorityEnum priority) {
    emit(state.copyWith(priority: priority));
  }

  void setCategory(TodoCategoryEnum category) {
    emit(state.copyWith(category: category));
  }

  void setDay(DateTime day) {
    emit(state.copyWith(day: day));
  }

  void setTime(TimeOfDay time) {
    emit(state.copyWith(time: time));
  }

  void setTitle(String title) {
    emit(state.copyWith(title: title));
  }

  void setCurrentTitle(TodoModel currentTodo, String newTitle) async {
    final updatedTodos = List<TodoModel>.from(state.todoList);
    updatedTodos[updatedTodos.indexOf(currentTodo)].copyWith(title: newTitle);

    List<Map<String, dynamic>> mappedTodos = [];
    for (var todo in updatedTodos) {
      mappedTodos.add(todo.toJson());
    }

    _firestore.collection("User").doc(_auth.currentUser!.uid).update(
      {
        "todoList": mappedTodos,
      },
    );
    emit(state.copyWith(todoList: updatedTodos));
  }

  void resetState() {
    emit(
      TodoState(
        category: null,
        day: null,
        priority: null,
        time: null,
        title: null,
        todoList: state.todoList,
        dropdownValue: state.dropdownValue,
        currentUser: state.currentUser,
        finishedTodoList: state.finishedTodoList,
      ),
    );
  }
}
