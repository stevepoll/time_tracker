import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget child;
  final ButtonStyle style;
  final double height;
  final VoidCallback? onPressed;

  const CustomElevatedButton({
    Key? key,
    required this.child,
    required this.style,
    this.height = 50,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        child: child,
        style: style,
        onPressed: onPressed,
      ),
    );
  }
}
