import 'dart:async';

import 'package:time_tracker/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});

  final AuthBase auth;

  final _modelController = StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  var _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (_model.formType == FormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
  void toggleForm() {
    final formType = _model.formType == FormType.signIn
        ? FormType.register
        : FormType.signIn;
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
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );
    _modelController.add(_model);
  }

  void reset() {
    _model = _model.copyWith(
      email: '',
      password: '',
      isLoading: false,
      submitted: false,
    );
    _modelController.add(_model);
  }
}
