import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes/app_router.gr.dart';
import '../../../utils/custom/custom_appbar.dart';
import '../../auth/widgets/flushbars.dart';
import '../cubit/friend_profile_cubit.dart';
import '../../auth/models/user_model.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

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
            floatingActionButton: state.isFriendWithUser!
                ? FloatingActionButton(
                    backgroundColor: Colors.blue,
                    child: const Icon(
                      Icons.message,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      context.router.push(MessageRoute(friend: widget.friend));
                    },
                  )
                : const SizedBox(),
            appBar: CustomAppbar(
              title: "${widget.friend.name}'s profile",
              centerTitle: false,
              leadingOnPressed: () {
                context.read<FriendProfileCubit>().cancelListener();
                context.router.maybePop();
              },
              actions: [
                SizedBox(width: 10.w),
                if (state.isFriendWithUser!)
                  Container(
                    padding: EdgeInsets.only(right: 20.w),
                    child: GestureDetector(
                      onTap: () {
                        context.read<FriendProfileCubit>().removeFriend();
                      },
                      child: Row(
                        children: [
                          Text(
                            "Remove friend",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    padding: EdgeInsets.only(right: 20.w),
                    child: GestureDetector(
                      onTap: () async {
                        if (state.isRequestSent) {
                          context
                              .read<FriendProfileCubit>()
                              .cancelFriendshipRequest();
                        } else {
                          if (_auth.currentUser!.displayName == null) {
                            customFlushbar(
                              "Set you name!!!",
                              Colors.red,
                            ).show(context);
                          }
                          context
                              .read<FriendProfileCubit>()
                              .sendFriendshipRequest();
                        }
                      },
                      child: Row(
                        children: [
                          if (!state.isRequestSent)
                            const Icon(Icons.add)
                          else
                            const Icon(Icons.cancel_sharp),
                          if (!state.isRequestSent)
                            Text(
                              "Add friend",
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          else
                            Text(
                              "Cancel",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              child: _FriendDetails(friend: widget.friend),
            ),
          );
        },
      ),
    );
  }
}

class _FriendDetails extends StatelessWidget {
  const _FriendDetails({required this.friend});

  final UserModel friend;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        Text(
          "name: ${friend.name!}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          "suranme${friend.surname ?? ""}",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
