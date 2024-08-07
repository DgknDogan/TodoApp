import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes/app_router.gr.dart';
import '../cubit/messages_initial_cubit.dart';

@RoutePage()
class MessagesInitialPage extends StatelessWidget {
  const MessagesInitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MessagesInitialCubit(),
      child: BlocBuilder<MessagesInitialCubit, MessagesInitialState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                  systemNavigationBarColor: Colors.white),
              toolbarHeight: 80.h,
              title: const Text("Message"),
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
            body: SafeArea(
              child: ListView.builder(
                itemCount: state.friendsList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.account_circle_rounded,
                      size: 50.r,
                    ),
                    splashColor: Colors.grey,
                    onTap: () => context.router
                        .push(MessageRoute(friend: state.friendsList[index])),
                    title: Text(
                      state.friendsList[index].name!,
                      style: TextStyle(
                        fontSize: 30.sp,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
