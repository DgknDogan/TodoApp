import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes/app_router.gr.dart';
import '../cubit/friend_profile_cubit.dart';
import '../model/user_model.dart';

@RoutePage()
class FriendProfilePage extends StatefulWidget {
  final UserModel friend;
  const FriendProfilePage({super.key, required this.friend});

  @override
  State<FriendProfilePage> createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FriendProfileCubit(widget.friend),
      child: BlocBuilder<FriendProfileCubit, FriendProfileState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue,
              child: const Icon(
                Icons.message,
                color: Colors.white,
              ),
              onPressed: () {
                context.router.push(MessageRoute(friend: widget.friend));
              },
            ),
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                  systemNavigationBarColor: Colors.white),
              leading: IconButton(
                  onPressed: () {
                    context.read<FriendProfileCubit>().close();
                    context.router.maybePop();
                  },
                  icon: const Icon(Icons.arrow_back)),
              actions: [
                SizedBox(width: 10.w),
                state.isFriendWithUser!
                    ? Container(
                        padding: EdgeInsets.only(right: 20.w),
                        child: GestureDetector(
                          onTap: () {
                            context.read<FriendProfileCubit>().removeFriend();
                          },
                          child: const Row(
                            children: [
                              Text("Remove friend"),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.only(right: 20.w),
                        child: GestureDetector(
                          onTap: () {
                            context
                                .read<FriendProfileCubit>()
                                .sendFriendshipRequest();
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.add),
                              Text("Add friend"),
                            ],
                          ),
                        ),
                      )
              ],
              toolbarHeight: 80.h,
              title: Text("${widget.friend.name}'s profile"),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      Color(0xff3461FD),
                      Color(0xAA3461FD),
                      Color(0x003461FD),
                    ],
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: FriendDetails(friend: widget.friend),
            ),
          );
        },
      ),
    );
  }
}

class FriendDetails extends StatelessWidget {
  const FriendDetails({
    super.key,
    required this.friend,
  });

  final UserModel friend;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text(
            "name: ${friend.name!}",
            style: TextStyle(fontSize: 16.sp),
          ),
          Text(
            "suranme${friend.surname ?? ""}",
            style: TextStyle(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
