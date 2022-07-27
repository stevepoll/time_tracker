import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/validators.dart';
import 'package:time_tracker/common_widgets/form_submit_button.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';

import 'email_sign_in_model.dart';

class EmailSignInFormStateful extends StatefulWidget {
  const EmailSignInFormStateful({Key? key}) : super(key: key);

  @override
  State<EmailSignInFormStateful> createState() =>
      _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormStateful>
    with EmailAndPasswordValidators {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  // ignore: prefer_final_fields
  FormType _formType = FormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = context.read<AuthBase>();
      if (_formType == FormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _toggleForm() {
    setState(() {
      _formType =
          _formType == FormType.signIn ? FormType.register : FormType.signIn;
      _submitted = false;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final buttonText = _formType == FormType.signIn
        ? {
            'primary': 'Sign In',
            'secondary': 'Need an account? Register',
          }
        : {
            'primary': 'Create an account',
            'secondary': 'Have an account? Sign in',
          };

    bool submitEnabled = emailValidator.isValid(_email) &&
        passwordValidator.isValid(_password) &&
        !_isLoading;

    return [
      _buildEmailField(),
      SizedBox(height: 8),
      _buildPasswordField(),
      SizedBox(height: 8),
      FormSubmitButton(
        onPressed: submitEnabled ? _submit : null,
        text: buttonText['primary']!,
      ),
      SizedBox(height: 8),
      TextButton(
        onPressed: _isLoading ? null : _toggleForm,
        child: Text(buttonText['secondary']!),
      ),
    ];
  }

  TextField _buildPasswordField() {
    bool showErrorText = _submitted && !passwordValidator.isValid(_password);
    return TextField(
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? invalidPasswordErrorText : null,
      ),
      obscureText: true,
      autocorrect: false,
      enabled: !_isLoading,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (_password) => _updateState(),
    );
  }

  TextField _buildEmailField() {
    bool showErrorText = _submitted && !emailValidator.isValid(_email);
    return TextField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'test@test.com',
          errorText: showErrorText ? invalidEmailErrorText : null),
      autocorrect: false,
      enabled: !_isLoading,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
      onChanged: (_email) => _updateState(),
    );
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }
}
