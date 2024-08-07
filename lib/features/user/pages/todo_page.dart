import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../routes/app_router.gr.dart';
import '../cubit/home_cubit.dart';
import '../cubit/todo_cubit.dart';
import '../data/enums/priority_enum.dart';
import '../data/enums/todo_category_enum.dart';
import '../model/todo_model.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

@RoutePage()
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              final cubit = context.read<TodoCubit>();
              showDialog(
                context: context,
                builder: (context) {
                  return BlocProvider.value(
                    value: cubit,
                    child: const TodoDialog(),
                  );
                },
              );
            },
            shape: const CircleBorder(),
            backgroundColor: const Color(0xff3461FD),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 35.r,
            ),
          ),
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () => context.router.maybePop(),
              child: const Icon(Icons.arrow_back),
            ),
            toolbarHeight: 80.h,
            title: Text(DateFormat.MMMEd().format(DateTime.now())),
            actions: const [SortDropDown()],
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
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                child: const Column(
                  children: [
                    ActiveTodos(),
                    FinishedTodos(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class FinishedTodos extends StatelessWidget {
  const FinishedTodos({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        return state.finishedTodoList.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    "Finished Todos",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...state.finishedTodoList.map(
                    (finishedTodo) {
                      return Column(
                        children: [
                          SizedBox(height: 20.h),
                          TodoCard(todo: finishedTodo),
                        ],
                      );
                    },
                  )
                ],
              )
            : const SizedBox();
      },
    );
  }
}

class ActiveTodos extends StatelessWidget {
  const ActiveTodos({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        return state.todoList.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    "Active Todos",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...state.todoList.map(
                    (todo) {
                      return Column(
                        children: [
                          SizedBox(height: 20.h),
                          TodoCard(todo: todo),
                        ],
                      );
                    },
                  ),
                ],
              )
            : const SizedBox();
      },
    );
  }
}

class SortDropDown extends StatelessWidget {
  const SortDropDown({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        return DropdownButton(
          value: state.dropdownValue,
          hint: const Text("Sort"),
          items: [
            DropdownMenuItem(
              value: 1,
              onTap: () => context.read<TodoCubit>().sortByFinishTime(),
              child: const Text("Sort by date"),
            ),
            DropdownMenuItem(
              value: 2,
              onTap: () => context.read<TodoCubit>().sortByPriority(),
              child: const Text("Sort by priority"),
            ),
          ],
          onChanged: (value) => context.read<TodoCubit>().changeDropDown(value),
        );
      },
    );
  }
}

class TodoDialog extends StatelessWidget {
  const TodoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TodoCubit>();

    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        return Dialog(
          backgroundColor: state.category?.color,
          child: Container(
            padding: EdgeInsets.all(20.r),
            constraints: BoxConstraints(
              minHeight: 200.h,
              maxHeight: 220.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Add Task",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    state.day != null
                        ? Text(DateFormat.MMMEd().format(state.day!))
                        : const SizedBox(),
                    state.priority != null
                        ? PriorityCard(priority: state.priority!)
                        : const SizedBox(width: 0)
                  ],
                ),
                SizedBox(height: 20.h),
                const TodoTitleForm(),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        TimePicker(cubit: cubit),
                        SizedBox(width: 16.w),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return BlocProvider.value(
                                  value: cubit,
                                  child: CategoryPicker(cubit: cubit),
                                );
                              },
                            );
                          },
                          child: Image.asset(
                            "assets/tag.png",
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return BlocProvider.value(
                                  value: cubit,
                                  child: PriorityPicker(cubit: cubit),
                                );
                              },
                            );
                          },
                          child: Image.asset(
                            "assets/flag.png",
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const NextButton(),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TimePicker extends StatelessWidget {
  final TodoCubit cubit;

  const TimePicker({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
          initialDate: DateTime.now(),
        );
        if (context.mounted) {
          final selectedTime = await showTimePicker(
              context: context, initialTime: TimeOfDay.now());
          if (context.mounted && selectedTime != null && selectedDate != null) {
            context.read<TodoCubit>().setDay(selectedDate);
            context.read<TodoCubit>().setTime(selectedTime);
          }
        }
      },
      child: Image.asset(
        "assets/timer.png",
        color: Colors.black,
      ),
    );
  }
}

class CategoryPicker extends StatelessWidget {
  final TodoCubit cubit;

  const CategoryPicker({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        return Dialog(
          child: Container(
            height: 200.h,
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                state.category == null
                    ? Text(
                        "Select Category",
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Selected: ",
                            style: TextStyle(
                              fontSize: 20.sp,
                            ),
                          ),
                          CategoryCard(category: state.category!)
                        ],
                      ),
                Row(
                  children: [
                    ...TodoCategoryEnum.values.map(
                      (category) {
                        return InkWell(
                          onTap: () {
                            context.read<TodoCubit>().setCategory(category);
                            context.router.maybePop();
                          },
                          child: CategoryCard(
                            category: category,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PriorityPicker extends StatelessWidget {
  final TodoCubit cubit;

  const PriorityPicker({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        return Dialog(
          child: Container(
            height: 200.h,
            padding: EdgeInsets.all(20.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text("3-urgent, 1-trivial"),
                state.priority == null
                    ? Text(
                        "Select Priority",
                        style: TextStyle(
                          fontSize: 20.sp,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Selected:",
                            style: TextStyle(
                              fontSize: 20.sp,
                            ),
                          ),
                          PriorityCard(
                            priority: state.priority!,
                          ),
                        ],
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...PriorityEnum.values.map(
                      (priority) {
                        return GestureDetector(
                          onTap: () => {
                            context.read<TodoCubit>().setPriority(priority),
                            context.router.maybePop(),
                          },
                          child: PriorityCard(
                            priority: priority,
                          ),
                        );
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class NextButton extends StatelessWidget {
  const NextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        return IconButton(
          onPressed: !context.read<TodoCubit>().isAbleToAddNewTodo()
              ? null
              : () {
                  context.read<TodoCubit>().addNewTodo(
                      getUpcomingTodos:
                          context.read<HomeCubit>().getUpcomingTodos);
                  context.read<TodoCubit>().resetState();
                  context.router.maybePop();
                },
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          style: const ButtonStyle(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          icon: const Icon(
            Icons.arrow_forward,
          ),
        );
      },
    );
  }
}

class TodoTitleForm extends StatefulWidget {
  const TodoTitleForm({super.key});

  @override
  State<TodoTitleForm> createState() => _TodoTitleFormState();
}

class _TodoTitleFormState extends State<TodoTitleForm> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        return Form(
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
              setState(() {});
              if (_formKey.currentState!.validate()) {
                context.read<TodoCubit>().setTitle(controller.text);
              }
            },
            controller: controller,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: controller.text.length < 6
                    ? const BorderSide()
                    : const BorderSide(color: Colors.green),
                borderRadius: BorderRadius.circular(10.r),
              ),
              hintText: "Title",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.r),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class TodoCard extends StatefulWidget {
  final TodoModel todo;

  const TodoCard({super.key, required this.todo});

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushRoute(TodoDetailsRoute(todo: widget.todo));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (context) {
                  context.read<TodoCubit>().deleteTodo(
                        currentTodo: widget.todo,
                        function: context.read<HomeCubit>().getUpcomingTodos,
                      );
                },
                icon: Icons.delete,
                backgroundColor: Colors.red,
                flex: 2,
              )
            ],
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            clipBehavior: Clip.hardEdge,
            height: 100.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: !widget.todo.isFinished!
                  ? widget.todo.category!.color
                  : Colors.grey.shade600,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  splashRadius: 0,
                  visualDensity:
                      const VisualDensity(horizontal: -4, vertical: -4),
                  shape: const CircleBorder(),
                  value: widget.todo.isFinished,
                  onChanged: (value) {
                    setState(() {});
                    if (widget.todo.isFinished! == false) {
                      context.read<TodoCubit>().finishTodo(widget.todo);
                    } else {
                      context.read<TodoCubit>().unfinishTodo(widget.todo);
                    }
                  },
                  side: BorderSide(
                    color: Colors.white,
                    width: 2.r,
                  ),
                  activeColor: Colors.white,
                  checkColor: Colors.grey.shade600,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TodoTitle(title: widget.todo.title!),
                      TodoDescription(
                        category: widget.todo.category!,
                        endDate: widget.todo.endDate!,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TodoTitle extends StatelessWidget {
  final String title;
  const TodoTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        fontSize: 20.sp,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class TodoDescription extends StatelessWidget {
  final TodoCategoryEnum category;
  final DateTime endDate;
  const TodoDescription(
      {super.key, required this.category, required this.endDate});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Ends at: ${DateFormat.MMMEd().format(endDate)}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
          Row(
            children: [
              CategoryCard(category: category),
              SizedBox(width: 10.w),
            ],
          )
        ],
      ),
    );
  }
}

class PriorityCard extends StatelessWidget {
  final PriorityEnum priority;

  const PriorityCard({super.key, required this.priority});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5.r),
      ),
      height: 30.h,
      child: Row(
        children: [
          const Icon(
            Icons.flag,
          ),
          SizedBox(
            width: 5.w,
          ),
          Text(
            priority.value.toString(),
          )
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final TodoCategoryEnum category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.r),
        color: category.color,
      ),
      height: 30.h,
      // width: 50.w,
      child: Row(
        children: [
          category.icon,
          SizedBox(width: 5.w),
          Text(
            category.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
