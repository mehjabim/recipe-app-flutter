import 'package:flutter/material.dart';
import '../Utils/constants.dart';

class MyIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;

  const MyIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: kprimaryColor.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
        splashRadius: 22,
      ),
    );
  }
}
