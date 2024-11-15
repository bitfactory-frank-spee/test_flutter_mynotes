import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:test_flutter_mynotes/constants/routes.dart';
import 'package:test_flutter_mynotes/services/auth/auth_exceptions.dart';
import 'package:test_flutter_mynotes/services/auth/auth_service.dart';
import 'package:test_flutter_mynotes/utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Spacer(),
            TextField(
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'Enter your email here',
              ),
            ),
            TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                hintText: 'Enter your password here',
              ),
            ),
            TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  await AuthService.firebase().createUser(
                    email: email,
                    password: password,
                  );
                  await AuthService.firebase().sendEmailVerification();
                  if (context.mounted) {
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                  }
                } on WeakPasswordAuthException {
                  if (context.mounted) {
                    await showErrorDialog(
                      context,
                      'The password provided is too weak.',
                    );
                  }
                } on EmailAlreadyInUseAuthException {
                  if (context.mounted) {
                    await showErrorDialog(
                      context,
                      'The email provided is already in use.',
                    );
                  }
                } on InvalidEmailAuthException {
                  if (context.mounted) {
                    await showErrorDialog(
                      context,
                      'The email provided is invalid.',
                    );
                  }
                } on ChannelErrorAuthException {
                  if (context.mounted) {
                    await showErrorDialog(
                      context,
                      'Email and password are required.',
                    );
                  }
                } on GenericAuthException {
                  if (context.mounted) {
                    await showErrorDialog(
                      context,
                      'An error occurred while trying to register.',
                    );
                  }
                }
              },
              child: const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              },
              child: const Text('Already registered? Login here!'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
