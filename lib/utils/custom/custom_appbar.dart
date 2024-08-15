import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final VoidCallback? leadingOnPressed;
  final Widget? leadingIcon;
  final List<Widget>? actions;
  final SystemUiOverlayStyle? systemOverlayStyle;
  const CustomAppbar({
    super.key,
    required this.title,
    required this.centerTitle,
    this.leadingOnPressed,
    this.leadingIcon,
    this.actions,
    this.systemOverlayStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: systemOverlayStyle,
      title: Text(title),
      centerTitle: centerTitle,
      leading: leadingIcon == null
          ? IconButton(
              onPressed: leadingOnPressed,
              icon: const Icon(Icons.arrow_back),
            )
          : IconButton(
              onPressed: leadingOnPressed,
              icon: leadingIcon!,
            ),
      actions: actions,
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
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 80.h);
}
