import 'package:flutter/material.dart';

class CustomSuffixWidget extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final VoidCallback onPressed;
  final String hintText;
  final GlobalKey<FormState> formKey;
  final bool isTextFieldChanged;
  const CustomSuffixWidget({
    super.key,
    required this.controller,
    required this.text,
    required this.onPressed,
    required this.hintText,
    required this.formKey,
    required this.isTextFieldChanged,
  });

  @override
  Widget build(BuildContext context) {
    return isTextFieldChanged
        ? IconButton(
            onPressed: onPressed,
            icon: const Icon(
              Icons.check_box,
              color: Colors.green,
            ),
          )
        : const SizedBox();
  }
}
