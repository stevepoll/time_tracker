import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_bloc.dart';
import 'package:time_tracker/common_widgets/form_submit_button.dart';
import 'package:time_tracker/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';

import 'email_sign_in_model.dart';

class EmailSignInFormBlocBased extends StatefulWidget {
  const EmailSignInFormBlocBased({Key? key, required this.bloc})
      : super(key: key);

  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    AuthBase auth = context.read<AuthBase>();
    return Provider<EmailSignInBloc>(
      create: (_) => EmailSignInBloc(auth: auth),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<EmailSignInBloc>(
        builder: (_, bloc, __) => EmailSignInFormBlocBased(bloc: bloc),
      ),
    );
  }

  @override
  State<EmailSignInFormBlocBased> createState() =>
      _EmailSignInFormBlocBasedState();
}

class _EmailSignInFormBlocBasedState extends State<EmailSignInFormBlocBased> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Sign in failed',
        exception: e,
      );
    }
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _toggleForm() {
    widget.bloc.toggleForm();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    return [
      _buildEmailField(model),
      SizedBox(height: 8),
      _buildPasswordField(model),
      SizedBox(height: 8),
      FormSubmitButton(
        onPressed: model.canSubmit ? _submit : null,
        text: model.buttonText['main']!,
      ),
      SizedBox(height: 8),
      TextButton(
        onPressed: model.isLoading ? null : _toggleForm,
        child: Text(model.buttonText['toggle']!),
      ),
    ];
  }

  TextField _buildPasswordField(EmailSignInModel model) {
    return TextField(
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: model.passwordErrorText,
      ),
      obscureText: true,
      autocorrect: false,
      enabled: !model.isLoading,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: widget.bloc.updatePassword,
    );
  }

  TextField _buildEmailField(EmailSignInModel model) {
    return TextField(
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@test.com',
        errorText: model.emailErrorText,
      ),
      autocorrect: false,
      enabled: !model.isLoading,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
      onChanged: widget.bloc.updateEmail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildChildren(model!),
            ),
          );
        });
  }
}
