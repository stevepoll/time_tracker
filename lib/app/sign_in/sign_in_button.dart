import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/custom_elevated_button.dart';

class SignInButton extends CustomElevatedButton {
  SignInButton({
    Key? key,
    required String text,
    required Color textColor,
    required ButtonStyle buttonStyle,
    required VoidCallback? onPressed,
  }) : super(
            key: key,
            child: Text(
              text,
              style: TextStyle(color: textColor),
            ),
            style: buttonStyle,
            onPressed: onPressed);
}
