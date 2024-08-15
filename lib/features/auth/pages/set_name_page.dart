import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes/app_router.gr.dart';
import '../../../utils/custom/custom_appbar.dart';
import '../../../utils/custom/custom_suffix_widget.dart';
import '../../../utils/custom/custom_text_field.dart';
import '../../user/cubit/home_cubit.dart';
import '../widgets/flushbars.dart';

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
      appBar: const CustomAppbar(
        title: "Set name",
        centerTitle: true,
        leadingIcon: SizedBox(),
      ),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_SetNameForm(nameController: nameController)],
          )),
    );
  }
}

class _SetNameForm extends StatefulWidget {
  const _SetNameForm({
    required this.nameController,
  });

  final TextEditingController nameController;

  @override
  State<_SetNameForm> createState() => _SetNameFormState();
}

class _SetNameFormState extends State<_SetNameForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Form(
          onChanged: () {
            setState(() {});
          },
          key: _nameFormKey,
          child: CustomTextField(
            textController: widget.nameController,
            validator: (name) {
              if (name!.length < 2) {
                return "Please enter a valid name";
              } else {
                return null;
              }
            },
            hintText: "Name",
            suffixIcon: CustomSuffixWidget(
              isTextFieldChanged: context.watch<HomeCubit>().isTextFieldChanged(
                    widget.nameController.text,
                  ),
              controller: widget.nameController,
              text: widget.nameController.text,
              onPressed: () {
                if (_nameFormKey.currentState!.validate()) {
                  context
                      .read<HomeCubit>()
                      .saveName(widget.nameController.text.trim());
                  customFlushbar("Saving name", Colors.green).show(context);
                  Future.delayed(
                    const Duration(seconds: 2),
                    () {
                      context.router.push(const InitialRoute());
                      widget.nameController.clear();
                    },
                  );
                }
              },
              hintText: "Name",
              formKey: _nameFormKey,
            ),
          ),
        );
      },
    );
  }
}
