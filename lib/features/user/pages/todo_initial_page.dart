import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/home_cubit.dart';
import '../cubit/todo_cubit.dart';

@RoutePage()
class TodoInitialPage extends StatelessWidget {
  const TodoInitialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoCubit(homeCubit: context.read<HomeCubit>()),
      child: const Scaffold(
        body: AutoRouter(),
      ),
    );
  }
}
