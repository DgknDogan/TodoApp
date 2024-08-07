import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../cubit/todo_cubit.dart';
import '../model/todo_model.dart';

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
          appBar: AppBar(
            actions: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return BlocProvider.value(
                        value: cubit,
                        child: ChangeTitleDialog(cubit: cubit, todo: todo),
                      );
                    },
                  );
                },
                child: const Icon(Icons.edit),
              ),
              Padding(padding: EdgeInsets.only(right: 20.w))
            ],
            toolbarHeight: 80.h,
            title: Text("${todo.title}"),
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
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 40.h),
                TaskDeatilRow(
                  assetPath: "assets/timer.png",
                  detailTitle: "Time",
                  info:
                      "${DateFormat.MEd().format(todo.endDate!)} ${todo.endDate!.hour}:${todo.endDate!.minute}",
                ),
                SizedBox(height: 40.h),
                TaskDeatilRow(
                  assetPath: "assets/tag.png",
                  detailTitle: "Category",
                  info: todo.category!.name,
                ),
                SizedBox(height: 40.h),
                TaskDeatilRow(
                  assetPath: "assets/flag.png",
                  detailTitle: "Priority",
                  info: todo.priority!.text,
                ),
              ],
            ),
          )),
        );
      },
    );
  }
}

class TaskDeatilRow extends StatelessWidget {
  const TaskDeatilRow({
    super.key,
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
              color: Colors.black,
              scale: 0.75.r,
            ),
            SizedBox(width: 10.w),
            Text(
              "Task $detailTitle:",
              style: TextStyle(fontSize: 16.sp),
            ),
          ],
        ),
        Text(
          info,
          style: TextStyle(fontSize: 16.sp),
        )
      ],
    );
  }
}

class ChangeTitleDialog extends StatefulWidget {
  const ChangeTitleDialog({
    super.key,
    required this.cubit,
    required this.todo,
  });

  final TodoCubit cubit;
  final TodoModel todo;

  @override
  State<ChangeTitleDialog> createState() => _ChangeTitleDialogState();
}

class _ChangeTitleDialogState extends State<ChangeTitleDialog> {
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
              style: TextStyle(fontSize: 20.sp),
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
            DialogButtons(widget: widget, controller: controller),
          ],
        ),
      ),
    );
  }
}

class DialogButtons extends StatefulWidget {
  const DialogButtons({
    super.key,
    required this.widget,
    required this.controller,
  });

  final ChangeTitleDialog widget;
  final TextEditingController controller;

  @override
  State<DialogButtons> createState() => _DialogButtonsState();
}

class _DialogButtonsState extends State<DialogButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () => context.router.maybePop(),
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            side: WidgetStatePropertyAll(
              BorderSide(color: Colors.black, width: 1.w),
            ),
          ),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(
              Color(0xff3461FD),
            ),
            shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
          onPressed: () => {
            widget.widget.cubit.setCurrentTitle(
              widget.widget.todo,
              widget.controller.text,
            ),
            widget.controller.clear(),
            context.router.maybePop()
          },
          child: const Text(
            "Change",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
