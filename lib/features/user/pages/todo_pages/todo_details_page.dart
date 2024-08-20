import 'package:auto_route/auto_route.dart';
import 'package:firebase_demo/utils/custom/custom_elevated_button.dart';
import 'package:firebase_demo/utils/custom/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../utils/custom/custom_appbar.dart';
import '../../cubit/todo_cubit.dart';
import '../../model/todo_model.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

@RoutePage()
class TodoDetailsPage extends StatelessWidget {
  final TodoModel todo;
  const TodoDetailsPage({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        final cubit = context.read<TodoCubit>();
        return Scaffold(
          appBar: CustomAppbar(
            centerTitle: false,
            leadingIcon: const Icon(Icons.arrow_back),
            leadingOnPressed: () {
              context.router.maybePop();
            },
            actions: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return BlocProvider.value(
                        value: cubit,
                        child: _ChangeTitleDialog(cubit: cubit, todo: todo),
                      );
                    },
                  );
                },
                child: const Icon(Icons.edit),
              ),
              Padding(padding: EdgeInsets.only(right: 20.w))
            ],
            title: "${todo.title}",
          ),
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 40.h),
                _TaskDeatilRow(
                  assetPath: "assets/timer.png",
                  detailTitle: "Time",
                  info:
                      "${DateFormat.MEd().format(todo.endDate!)} ${todo.endDate!.hour}:${todo.endDate!.minute}",
                ),
                SizedBox(height: 40.h),
                _TaskDeatilRow(
                  assetPath: "assets/tag.png",
                  detailTitle: "Category",
                  info: todo.category!.name,
                ),
                SizedBox(height: 40.h),
                _TaskDeatilRow(
                  assetPath: "assets/flag.png",
                  detailTitle: "Priority",
                  info: todo.priority!.text,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TaskDeatilRow extends StatelessWidget {
  const _TaskDeatilRow({
    required this.assetPath,
    required this.detailTitle,
    required this.info,
  });

  final String assetPath;
  final String detailTitle;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              assetPath,
              scale: 0.75.r,
            ),
            SizedBox(width: 10.w),
            Text(
              "Task $detailTitle:",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        Text(
          info,
          style: Theme.of(context).textTheme.bodyMedium,
        )
      ],
    );
  }
}

class _ChangeTitleDialog extends StatefulWidget {
  const _ChangeTitleDialog({
    required this.cubit,
    required this.todo,
  });

  final TodoCubit cubit;
  final TodoModel todo;

  @override
  State<_ChangeTitleDialog> createState() => __ChangeTitleDialogState();
}

class __ChangeTitleDialogState extends State<_ChangeTitleDialog> {
  final controller = TextEditingController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20.r),
        constraints: BoxConstraints(
          minHeight: 200.h,
          maxHeight: 220.h,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Edit title",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                validator: (value) {
                  if (value!.length < 6) {
                    return "Title must be longer!";
                  } else {
                    return null;
                  }
                },
                onChanged: (value) {
                  if (_formKey.currentState!.validate()) {}
                },
                controller: controller,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: controller.text.length < 6
                        ? const BorderSide()
                        : const BorderSide(
                            color: Colors.green,
                          ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  hintText: widget.todo.title,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.r),
                    ),
                  ),
                ),
              ),
            ),
            _DialogButtons(widget: widget, controller: controller),
          ],
        ),
      ),
    );
  }
}

class _DialogButtons extends StatefulWidget {
  const _DialogButtons({
    required this.widget,
    required this.controller,
  });

  final _ChangeTitleDialog widget;
  final TextEditingController controller;

  @override
  State<_DialogButtons> createState() => _DialogButtonsState();
}

class _DialogButtonsState extends State<_DialogButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomTextButton(
            text: "Cancel",
            onPressed: () {
              context.router.maybePop();
            }),
        CustomElevatedButton(
          height: 30,
          width: 70,
          onPressed: () {
            widget.widget.cubit.setCurrentTitle(
              widget.widget.todo,
              widget.controller.text,
            );
            widget.controller.clear();
            context.router.maybePop();
          },
          text: "Change",
        ),
      ],
    );
  }
}
