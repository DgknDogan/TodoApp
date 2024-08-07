import 'package:auto_route/auto_route.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../routes/app_router.gr.dart';
import '../cubit/social_cubit.dart';

final TextEditingController _controller = TextEditingController();

@RoutePage()
class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FriendCubit(),
      child: BlocBuilder<FriendCubit, SocialState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 80.h,
              title: const Text("Social"),
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
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    TypeAheadField(
                      controller: _controller,
                      emptyBuilder: (context) {
                        return const SizedBox();
                      },
                      builder: (context, controller, focusNode) {
                        return TextField(
                          onChanged: (name) {
                            context
                                .read<FriendCubit>()
                                .updateSuggestedList(name);
                          },
                          controller: controller,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Search a friend",
                          ),
                        );
                      },
                      itemBuilder: (context, value) {
                        return ListTile(
                          title: Text(value.name!),
                        );
                      },
                      onSelected: (friend) => {
                        context.router.push(FriendProfileRoute(friend: friend)),
                        _controller.clear()
                      },
                      suggestionsCallback: (search) async => await context
                          .read<FriendCubit>()
                          .getSuggestedList(search),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
