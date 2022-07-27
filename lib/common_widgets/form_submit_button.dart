import 'package:flutter/material.dart';
import 'package:time_tracker/common_widgets/custom_elevated_button.dart';
import 'package:time_tracker/util/constants.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    Key? key,
    required String text,
    VoidCallback? onPressed,
  }) : super(
            key: key,
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            height: 44,
            onPressed: onPressed,
            style: kSubmitButtonStyle);
}
