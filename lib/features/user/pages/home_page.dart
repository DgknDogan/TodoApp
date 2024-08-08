import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../routes/app_router.gr.dart';
import '../cubit/home_cubit.dart';
import '../model/chart_model.dart';
import '../model/user_model.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<HomeCubit>()
      ..getNewMessageNotifiaction()
      ..getUserName()
      ..getTopUsers()
      ..initializeChartData()
      ..getUpcomingTodos()
      ..getFriendRequestCount()
      ..countProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          drawer: const MainDrawer(),
          backgroundColor: Colors.white,
          appBar: AppBar(
            foregroundColor: Colors.white,
            title: Text(
              "Welcome ${state.userName ?? ""}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            toolbarHeight: 80.h,
            centerTitle: true,
            backgroundColor: const Color(0xAA3461FD),
            leading: Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.menu),
                );
              },
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              return Future<void>.delayed(
                const Duration(seconds: 1),
                () {
                  context.read<HomeCubit>().getTopUsers();
                  context.read<HomeCubit>().getUserName();
                  context.read<HomeCubit>().getFriendRequestCount();
                },
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 24.h),
                      const TodoLeaderboard(),
                      SizedBox(height: 24.h),
                      const CompleteProfileCard(),
                      SizedBox(height: 24.h),
                      const UpcomingTodosCard(),
                      SizedBox(height: 24.h),
                      const NewFriendNotificationCard(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// TodoLeaderboard section
class TodoLeaderboard extends StatelessWidget {
  const TodoLeaderboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 20.h),
              height: 150.h,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 2.w,
                    color: Colors.black,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Second place
                  TopUser(
                    containerHeight: 40,
                    user: state.secondUser,
                    userPlace: 2,
                    color: Colors.grey,
                  ),
                  // First place
                  TopUser(
                    containerHeight: 50,
                    user: state.firstUser,
                    userPlace: 1,
                    color: Colors.amber,
                  ),
                  // Thi
                  TopUser(
                    containerHeight: 30,
                    user: state.thirdUser,
                    userPlace: 3,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
            Positioned(
              top: -12.h,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: const BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    SvgPicture.asset("assets/Svg/crown.svg"),
                    Text(
                      "Leaderboard",
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    SvgPicture.asset("assets/Svg/crown.svg"),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class TopUser extends StatelessWidget {
  final UserModel? user;
  final int userPlace;
  final int containerHeight;
  final Color color;

  const TopUser({
    super.key,
    required this.user,
    required this.userPlace,
    required this.containerHeight,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(user?.name ?? ""),
        user != null ? Text("points: ${user?.points}") : const SizedBox(),
        Container(
          width: 75.w,
          height: containerHeight.h,
          decoration: const BoxDecoration(color: Colors.black),
          child: Center(
            child: Text(
              userPlace.toString(),
              style: TextStyle(
                color: color,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}
// TodoLeaderboard section

// CompleteProfileCard section
class CompleteProfileCard extends StatefulWidget {
  const CompleteProfileCard({super.key});

  @override
  State<CompleteProfileCard> createState() => _CompleteProfileCardState();
}

class _CompleteProfileCardState extends State<CompleteProfileCard> {
  @override
  void initState() {
    context.read<HomeCubit>().initializeChartData();
    context.read<HomeCubit>().countProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return state.isChartDeleted && state.count == 3
            ? const SizedBox()
            : InkWell(
                onTap: () => context.router.push(const ProfileRoute()),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(width: 2.w),
                      ),
                      width: double.infinity,
                      height: 200.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 16.w),
                                child: Text(
                                  "Finish your profile \nfor leaderboard",
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                              ),
                              const ChartStack()
                            ],
                          ),
                        ],
                      ),
                    ),
                    state.count == 3
                        ? IconButton(
                            onPressed: () =>
                                context.read<HomeCubit>().deleteChartCard(),
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: 30.r,
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              );
      },
    );
  }
}

class ChartStack extends StatelessWidget {
  const ChartStack({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 150.w,
              height: 150.h,
              child: SfCircularChart(
                margin: EdgeInsets.zero,
                series: <CircularSeries<ChartData, String>>[
                  DoughnutSeries(
                    pointColorMapper: (ChartData data, _) => data.color,
                    xValueMapper: (ChartData data, _) => data.x,
                    yValueMapper: (ChartData data, _) => data.y,
                    dataSource: state.data,
                  ),
                ],
              ),
            ),
            Text(
              "${state.count}/3",
              style: TextStyle(fontSize: 16.sp),
            )
          ],
        );
      },
    );
  }
}
// CompleteProfileCard section

// UpcomingTodosCard section
class UpcomingTodosCard extends StatelessWidget {
  const UpcomingTodosCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return state.upcomingTodos.isNotEmpty
            ? InkWell(
                highlightColor: Colors.red.shade200,
                splashColor: Colors.red.shade200,
                borderRadius: BorderRadius.all(Radius.circular(14.r)),
                onTap: () {
                  context.router.push(const TodoInitialRoute());
                },
                child: Stack(
                  alignment: Alignment.topLeft,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      clipBehavior: Clip.none,
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.red.shade900,
                          width: 3.r,
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            "${state.upcomingTodos.length} upcoming todos",
                            style:
                                TextStyle(fontSize: 20.sp, color: Colors.red),
                          ),
                          const Text(
                            "Tap to see",
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: -10.h,
                      left: -10.w,
                      child: Transform.rotate(
                        angle: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.red,
                                blurRadius: 6.r,
                                blurStyle: BlurStyle.outer,
                              ),
                            ],
                            color: Colors.red.shade900,
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Icon(
                            Icons.notifications_active,
                            color: Colors.red,
                            size: 40.r,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : const SizedBox();
      },
    );
  }
}
// UpcomingTodosCard section

// NewFriendNotificationCard section
class NewFriendNotificationCard extends StatelessWidget {
  const NewFriendNotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return state.newFriendRequestCount != 0
            ? InkWell(
                highlightColor: Colors.blue.shade200,
                splashColor: Colors.blue.shade200,
                borderRadius: BorderRadius.all(Radius.circular(14.r)),
                onTap: () {
                  context.router.push(const ProfileRoute());
                },
                child: Stack(
                  alignment: Alignment.topRight,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      clipBehavior: Clip.none,
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue.shade900,
                          width: 3.r,
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            "${state.newFriendRequestCount} friend requests",
                            style:
                                TextStyle(fontSize: 20.sp, color: Colors.blue),
                          ),
                          const Text(
                            "Tap to see",
                            style: TextStyle(color: Colors.blue),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: -10.h,
                      right: -10.w,
                      child: Transform.rotate(
                        angle: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue,
                                blurRadius: 6.r,
                                blurStyle: BlurStyle.outer,
                              ),
                            ],
                            color: Colors.blue.shade900,
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Icon(
                            Icons.notifications_active,
                            color: Colors.blue,
                            size: 40.r,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : const SizedBox();
      },
    );
  }
}
// NewFriendNotificationCard section

// Main Drawer
class MainDrawer extends StatelessWidget {
  const MainDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).padding.top.h,
        ),
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.checklist_rtl_sharp,
                size: 30.r,
              ),
              title: Text(
                "Todos",
                style: TextStyle(fontSize: 20.sp),
              ),
              onTap: () {
                context.router.maybePop();
                context.router.push(const TodoInitialRoute());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle_sharp,
                size: 30.r,
              ),
              title: Text(
                "Profile",
                style: TextStyle(fontSize: 20.sp),
              ),
              onTap: () {
                context.router.maybePop();
                context.router.push(const ProfileRoute());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.group,
                size: 30.r,
              ),
              title: Text(
                "Social",
                style: TextStyle(fontSize: 20.sp),
              ),
              onTap: () {
                context.router.maybePop();
                context.router.push(const SocialRoute());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.message,
                size: 30.r,
              ),
              title: Text(
                "Messages",
                style: TextStyle(fontSize: 20.sp),
              ),
              onTap: () {
                context.router.maybePop();
                context.router.push(const MessagesInitialRoute());
              },
            ),
            const Spacer(),
            const LogOutButton()
          ],
        ),
      ),
    );
  }
}

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      height: 60.h,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          minimumSize: const WidgetStatePropertyAll(Size.zero),
          elevation: const WidgetStatePropertyAll(8),
          shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(14.r),
              ),
            ),
          ),
          shadowColor: const WidgetStatePropertyAll(Color(0xff3461FD)),
          backgroundColor: const WidgetStatePropertyAll(Color(0xff3461FD)),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("You are logging out"),
                content: Text("Are you sure?"),
                actionsAlignment: MainAxisAlignment.spaceEvenly,
                actions: [LogOutDialogButtons()],
              );
            },
          );
        },
        child: Text(
          "Log out",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}

class LogOutDialogButtons extends StatelessWidget {
  const LogOutDialogButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () async {
            context.router.maybePop();
          },
          style: ButtonStyle(
            elevation: const WidgetStatePropertyAll(5),
            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(14.r),
                ),
              ),
            ),
            shadowColor: const WidgetStatePropertyAll(Color(0xff3461FD)),
            backgroundColor: const WidgetStatePropertyAll(Color(0xff3461FD)),
          ),
          child: const Text(
            "No",
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<HomeCubit>().logOut();
            context.read<HomeCubit>().cancelListener();
            context.router.maybePop();
            context.router.replace(const LoginRoute());
          },
          style: ButtonStyle(
            elevation: const WidgetStatePropertyAll(5),
            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(14.r),
                ),
              ),
            ),
            shadowColor: const WidgetStatePropertyAll(Color(0xff3461FD)),
            backgroundColor: const WidgetStatePropertyAll(Color(0xff3461FD)),
          ),
          child: const Text(
            "Yes",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
