import 'package:flutter/material.dart';

const kBigDarkTextLabel = TextStyle(
  color: Colors.black87,
  fontSize: 32,
  fontWeight: FontWeight.w600,
);

final kSignInButtonShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));

final kSignInGoogleButtonStyle = ElevatedButton.styleFrom(
  primary: Colors.white,
  shape: kSignInButtonShape,
);

final kSignInFacebookButtonStyle = ElevatedButton.styleFrom(
  primary: Color(0xff334d92),
  shape: kSignInButtonShape,
);

final kSignInEmailButtonStyle = ElevatedButton.styleFrom(
  primary: Colors.teal[700],
  shape: kSignInButtonShape,
);

final kSignInAnonButtonStyle = ElevatedButton.styleFrom(
  primary: Colors.lime[300],
  shape: kSignInButtonShape,
);

final kSubmitButtonStyle = ElevatedButton.styleFrom(
  primary: Colors.indigo[700],
  shape: kSignInButtonShape,
);
