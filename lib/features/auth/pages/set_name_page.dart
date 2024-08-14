import 'package:auto_route/auto_route.dart';
import 'package:firebase_demo/features/user/cubit/home_cubit.dart';
import 'package:firebase_demo/features/auth/widgets/flushbars.dart';
import 'package:firebase_demo/routes/app_router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();

@RoutePage()
class SetNamePage extends StatefulHookWidget {
  const SetNamePage({super.key});

  @override
  State<SetNamePage> createState() => _SetNamePageState();
}

class _SetNamePageState extends State<SetNamePage> {
  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        toolbarHeight: 80.h,
        centerTitle: true,
        title: const Text("Set name"),
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
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _nameFormKey,
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value!.length < 2) {
                        return "Please enter a valid name";
                      } else {
                        return null;
                      }
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      suffixIcon: context
                              .watch<HomeCubit>()
                              .isTextFieldChanged(nameController)
                          ? IconButton(
                              onPressed: () {
                                if (_nameFormKey.currentState!.validate()) {
                                  context
                                      .read<HomeCubit>()
                                      .saveName(nameController.text.trim());
                                  successFlushbar("Saving name").show(context);
                                  Future.delayed(
                                    const Duration(seconds: 2),
                                    () {
                                      context.router.push(const InitialRoute());
                                      nameController.clear();
                                    },
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.check_box,
                                color: Colors.green,
                              ),
                            )
                          : const SizedBox(),
                      hintText: "Name",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(14.r),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xff3461FD)),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
