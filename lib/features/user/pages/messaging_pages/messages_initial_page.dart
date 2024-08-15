import 'package:auto_route/auto_route.dart';
import 'package:firebase_demo/utils/custom/custom_appbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../routes/app_router.gr.dart';
import '../../cubit/messages_initial_cubit.dart';

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
            appBar: CustomAppbar(
              systemOverlayStyle: const SystemUiOverlayStyle(
                systemNavigationBarColor: Colors.white,
              ),
              title: "Message",
              centerTitle: false,
              leadingOnPressed: () {
                context.router.maybePop();
              },
            ),
            body: ListView.builder(
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
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
