import 'package:auto_route/auto_route.dart';
import 'package:firebase_demo/utils/custom/custom_appbar.dart';
import 'package:firebase_demo/utils/custom/custom_text_field.dart';

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
            appBar: CustomAppbar(
              title: "Social",
              centerTitle: false,
              leadingOnPressed: () {
                context.router.maybePop();
              },
            ),
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [SizedBox(height: 20.h), const _FriendSearchBar()],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FriendSearchBar extends StatefulWidget {
  const _FriendSearchBar();

  @override
  State<_FriendSearchBar> createState() => _FriendSearchBarState();
}

class _FriendSearchBarState extends State<_FriendSearchBar> {
  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      controller: _controller,
      emptyBuilder: (context) {
        return const SizedBox();
      },
      builder: (context, controller, focusNode) {
        return CustomTextField(
          textController: controller,
          hintText: "Search a friend",
          onChanged: (name) {
            setState(() {});
            context.read<FriendCubit>().updateSuggestedList(name);
          },
          focusNode: focusNode,
        );
      },
      itemBuilder: (context, value) {
        return ListTile(
          title: Text(
            value.name!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      },
      onSelected: (friend) => {
        context.router.push(FriendProfileRoute(friend: friend)),
        _controller.clear()
      },
      suggestionsCallback: (search) async =>
          await context.read<FriendCubit>().getSuggestedList(search),
    );
  }
}
