import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../routes/app_router.gr.dart';
import '../../user/cubit/home_cubit.dart';
import '../../user/cubit/splash_cubit.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    const beginColor = Colors.red;
    const endColor = Colors.green;

    _animation = ColorTween(
      begin: beginColor,
      end: endColor,
    ).animate(_controller);

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit(),
      child: BlocConsumer<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state.isRemembered) {
            context.read<HomeCubit>().getTopUsers();
            Future.delayed(
              const Duration(seconds: 3),
              () {
                context.router.push(const InitialRoute());
              },
            );
          } else {
            Future.delayed(
              const Duration(seconds: 3),
              () {
                context.router.push(const CreateAccountRoute());
              },
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(backgroundColor: Colors.white),
            body: SafeArea(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CircularProgressIndicator(color: _animation.value);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
