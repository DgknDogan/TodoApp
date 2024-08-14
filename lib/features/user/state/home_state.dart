part of '../cubit/home_cubit.dart';

final class HomeState {
  final List<ChartData> data;
  final int count;
  final bool isChartDeleted;
  final List<TodoModel> upcomingTodos;
  final String? userName;
  final int newFriendRequestCount;
  final bool isLoading;

  final UserModel? firstUser;
  final UserModel? secondUser;
  final UserModel? thirdUser;

  HomeState({
    required this.data,
    required this.count,
    required this.isChartDeleted,
    required this.upcomingTodos,
    required this.newFriendRequestCount,
    required this.isLoading,
    this.userName,
    this.firstUser,
    this.secondUser,
    this.thirdUser,
  });

  HomeState copyWith({
    List<ChartData>? data,
    int? count,
    bool? isChartDeleted,
    List<TodoModel>? upcomingTodos,
    String? userName,
    UserModel? firstUser,
    UserModel? secondUser,
    UserModel? thirdUser,
    int? newFriendRequestCount,
    bool? isLoading,
  }) {
    return HomeState(
        data: data ?? this.data,
        count: count ?? this.count,
        isChartDeleted: isChartDeleted ?? this.isChartDeleted,
        upcomingTodos: upcomingTodos ?? this.upcomingTodos,
        userName: userName ?? this.userName,
        firstUser: firstUser ?? this.firstUser,
        secondUser: secondUser ?? this.secondUser,
        thirdUser: thirdUser ?? this.thirdUser,
        newFriendRequestCount:
            newFriendRequestCount ?? this.newFriendRequestCount,
        isLoading: isLoading ?? this.isLoading);
  }
}
