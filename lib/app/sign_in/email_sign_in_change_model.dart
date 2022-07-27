import 'package:flutter/foundation.dart';
import 'package:time_tracker/app/sign_in/validators.dart';
import 'package:time_tracker/services/auth.dart';

import 'email_sign_in_model.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  final AuthBase auth;
  String email;
  String password;
  FormType formType;
  bool isLoading;
  bool submitted;

  EmailSignInChangeModel({
    required this.auth,
    this.email = '',
    this.password = '',
    this.formType = FormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  Map<String, String> get buttonText {
    return formType == FormType.signIn
        ? {'main': 'Sign In', 'toggle': 'Need an account? Register'}
        : {'main': 'Create an account', 'toggle': 'Have an account? Sign in'};
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !isLoading;
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == FormType.signIn) {
        await auth.signInWithEmailAndPassword(email, password);
      } else {
        await auth.createUserWithEmailAndPassword(email, password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String? get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String? get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
  void toggleForm() {
    final formType =
        this.formType == FormType.signIn ? FormType.register : FormType.signIn;
    reset();
    updateWith(formType: formType);
  }

  void updateWith({
    String? email,
    String? password,
    FormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  void reset() {
    email = '';
    password = '';
    isLoading = false;
    submitted = false;
    notifyListeners();
  }
}
