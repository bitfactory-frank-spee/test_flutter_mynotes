import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:test_flutter_mynotes/constants/routes.dart';
import 'package:test_flutter_mynotes/services/auth/auth_exceptions.dart';
import 'package:test_flutter_mynotes/services/auth/auth_service.dart';
import 'package:test_flutter_mynotes/utilities/dialogs/error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
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
                  await AuthService.firebase().logIn(
                    email: email,
                    password: password,
                  );
                  final user = AuthService.firebase().currentUser;
                  if (context.mounted) {
                    if (user?.isEmailVerified ?? false) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        notesRoute,
                        (_) => false,
                      );
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute,
                        (_) => false,
                      );
                    }
                  }
                } on InvalidCredentialAuthException {
                  if (context.mounted) {
                    await showErrorDialog(
                      context,
                      'Wrong credentials provided.',
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
                      'An error occurred while trying to log in.',
                    );
                  }
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  registerRoute,
                  (_) => false,
                );
              },
              child: const Text('Not registered yet? Register here!'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
