import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo/utils/custom/custom_appbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../routes/app_router.gr.dart';
import '../cubit/home_cubit.dart';
import '../model/chart_model.dart';
import '../../auth/models/user_model.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
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
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    if (auth.currentUser == null) return;
    final currentUserDoc =
        firestore.collection("User").doc(auth.currentUser!.uid);
    if (state == AppLifecycleState.resumed) {
      currentUserDoc.update({
        "isActive": true,
      });
    } else {
      currentUserDoc.update({
        "isActive": false,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: const MainDrawer(),
          backgroundColor: Colors.white,
          appBar: CustomAppbar(
            centerTitle: true,
            title: "Welcome ${state.userName ?? ""}",
            leadingOnPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
            leadingIcon: const Icon(Icons.menu),
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
                      const _TodoLeaderboard(),
                      SizedBox(height: 24.h),
                      const _CompleteProfileCard(),
                      SizedBox(height: 24.h),
                      const _UpcomingTodosCard(),
                      SizedBox(height: 24.h),
                      const _NewFriendNotificationCard(),
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

// _TodoLeaderboard section
class _TodoLeaderboard extends StatelessWidget {
  const _TodoLeaderboard();

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
                  _TopUser(
                    containerHeight: 40,
                    user: state.secondUser,
                    userPlace: 2,
                    color: Colors.grey,
                  ),
                  // First place
                  _TopUser(
                    containerHeight: 50,
                    user: state.firstUser,
                    userPlace: 1,
                    color: Colors.amber,
                  ),
                  // Thi
                  _TopUser(
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
                      style: Theme.of(context).textTheme.bodyLarge,
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

class _TopUser extends StatelessWidget {
  final UserModel? user;
  final int userPlace;
  final int containerHeight;
  final Color color;

  const _TopUser({
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
        Text(
          user?.name ?? "",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        user != null
            ? Text(
                "points: ${user?.points}",
                style: Theme.of(context).textTheme.bodySmall,
              )
            : const SizedBox(),
        Container(
          width: 75.w,
          height: containerHeight.h,
          decoration: const BoxDecoration(color: Colors.black),
          child: Center(
            child: Text(
              userPlace.toString(),
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: color),
            ),
          ),
        )
      ],
    );
  }
}
// _TodoLeaderboard section

// _CompleteProfileCard section
class _CompleteProfileCard extends StatefulWidget {
  const _CompleteProfileCard();

  @override
  State<_CompleteProfileCard> createState() => _CompleteProfileCardState();
}

class _CompleteProfileCardState extends State<_CompleteProfileCard> {
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
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                              const _ChartStack()
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

class _ChartStack extends StatelessWidget {
  const _ChartStack();

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
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        );
      },
    );
  }
}
// _CompleteProfileCard section

// _UpcomingTodosCard section
class _UpcomingTodosCard extends StatelessWidget {
  const _UpcomingTodosCard();

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
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.red),
                          ),
                          Text(
                            "Tap to see",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.red),
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
// _UpcomingTodosCard section

// _NewFriendNotificationCard section
class _NewFriendNotificationCard extends StatelessWidget {
  const _NewFriendNotificationCard();

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
                          Text("${state.newFriendRequestCount} friend requests",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: Colors.blue)),
                          Text(
                            "Tap to see",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.blue),
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
// _NewFriendNotificationCard section

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
                style: Theme.of(context).textTheme.bodyLarge,
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
                style: Theme.of(context).textTheme.bodyLarge,
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
                style: Theme.of(context).textTheme.bodyLarge,
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
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              onTap: () {
                context.router.maybePop();
                context.router.push(const MessagesInitialRoute());
              },
            ),
            const Spacer(),
            const _LogOutButton()
          ],
        ),
      ),
    );
  }
}

class _LogOutButton extends StatelessWidget {
  const _LogOutButton();

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
              return AlertDialog(
                title: Text(
                  "You are logging out",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                content: Text("Are you sure?",
                    style: Theme.of(context).textTheme.bodySmall),
                actionsAlignment: MainAxisAlignment.spaceEvenly,
                actions: const [_LogOutDialogButtons()],
              );
            },
          );
        },
        child: const Text(
          "Log out",
        ),
      ),
    );
  }
}

class _LogOutDialogButtons extends StatelessWidget {
  const _LogOutDialogButtons();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _LogOutDialogButton(
            onPressed: () {
              context.router.maybePop();
            },
            text: "No"),
        _LogOutDialogButton(
          onPressed: () {
            context.read<HomeCubit>().logOut();
            context.read<HomeCubit>().cancelListener();
            context.router.maybePop();
            context.router.replace(const LoginRoute());
          },
          text: "Yes",
        ),
      ],
    );
  }
}

class _LogOutDialogButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const _LogOutDialogButton({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      width: 60.w,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
