import 'package:time_tracker/app/sign_in/validators.dart';

enum FormType { signIn, register }

class EmailSignInModel with EmailAndPasswordValidators {
  final String email;
  final String password;
  final FormType formType;
  final bool isLoading;
  final bool submitted;

  EmailSignInModel({
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

  String? get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String? get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(email);
    return showErrorText ? invalidEmailErrorText : null;
  }

  EmailSignInModel copyWith({
    String? email,
    String? password,
    FormType? formType,
    bool? isLoading,
    bool? submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }
}
