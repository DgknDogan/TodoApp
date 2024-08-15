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
import '../widgets/drawer.dart';

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
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 24.h),
                    const _TodoLeaderboard(),
                    SizedBox(height: 24.h),
                    const _CompleteProfileCard(),
                    SizedBox(height: 24.h),
                    _NotificationCard(
                      splashColor: Colors.red.shade200,
                      onPressed: () {
                        context.router.push(const TodoInitialRoute());
                      },
                      mainText: "${state.upcomingTodos.length} upcoming todos",
                      ifCheck: state.upcomingTodos.isNotEmpty,
                      textColor: Colors.red,
                      borderColor: Colors.red.shade900,
                      iconColor: Colors.red,
                      alignment: Alignment.topLeft,
                      top: 10,
                      left: 10,
                      right: null,
                    ),
                    SizedBox(height: 24.h),
                    _NotificationCard(
                      splashColor: Colors.blue.shade200,
                      onPressed: () {
                        context.router.push(const ProfileRoute());
                      },
                      mainText:
                          "${state.newFriendRequestCount} friend requests",
                      ifCheck: state.newFriendRequestCount != 0,
                      textColor: Colors.blue,
                      borderColor: Colors.blue.shade900,
                      iconColor: Colors.blue,
                      alignment: Alignment.topRight,
                      top: 10,
                      left: null,
                      right: 10,
                    )
                  ],
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

class _NotificationCard extends StatelessWidget {
  final String mainText;
  final bool ifCheck;
  final Color textColor;
  final Color borderColor;
  final Color iconColor;
  final Color splashColor;
  final Alignment alignment;
  final VoidCallback onPressed;

  final double top;
  final double? left;
  final double? right;

  const _NotificationCard({
    required this.splashColor,
    required this.onPressed,
    required this.mainText,
    required this.ifCheck,
    required this.textColor,
    required this.borderColor,
    required this.iconColor,
    required this.alignment,
    required this.top,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return ifCheck
            ? InkWell(
                highlightColor: splashColor,
                splashColor: splashColor,
                borderRadius: BorderRadius.all(Radius.circular(14.r)),
                onTap: onPressed,
                child: Stack(
                  alignment: alignment,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      clipBehavior: Clip.none,
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: borderColor,
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
                                ?.copyWith(color: textColor),
                          ),
                          Text(
                            "Tap to see",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: textColor),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: -top.h,
                      left: left != null ? -left!.w : null,
                      right: right != null ? -right!.w : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: borderColor,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Icon(
                          Icons.notifications_active,
                          color: iconColor,
                          size: 40.r,
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
