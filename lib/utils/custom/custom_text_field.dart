import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textController;
  final String? Function(String?)? validator;
  final bool? isObsecured;
  final Widget? suffixIcon;
  final String hintText;
  final GlobalKey<FormState>? globalKey;
  final Function(String)? onChanged;
  final FocusNode? focusNode;

  const CustomTextField({
    super.key,
    required this.textController,
    required this.hintText,
    this.validator,
    this.suffixIcon,
    this.isObsecured,
    this.globalKey,
    this.onChanged,
    this.focusNode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(14.r),
        ),
      ),
      child: TextFormField(
        focusNode: widget.focusNode,
        controller: widget.textController,
        validator: widget.validator,
        obscuringCharacter: "●",
        obscureText: widget.isObsecured ?? false,
        cursorErrorColor: Colors.red,
        cursorColor: Theme.of(context).colorScheme.outline,
        decoration: InputDecoration(
          suffixIcon: widget.suffixIcon,
          hintText: widget.hintText,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}
