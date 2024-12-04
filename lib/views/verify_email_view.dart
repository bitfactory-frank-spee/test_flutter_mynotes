import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_mynotes/extensions/buildcontext/loc.dart';
import 'package:test_flutter_mynotes/services/auth/auth_exceptions.dart';
import 'package:test_flutter_mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:test_flutter_mynotes/services/auth/bloc/auth_event.dart';
import 'package:test_flutter_mynotes/services/auth/bloc/auth_state.dart';
import 'package:test_flutter_mynotes/utilities/dialogs/error_dialog.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateNeedsVerification) {
          if (state.exception is TooManyRequestsAuthException) {
            await showErrorDialog(
              context,
              context.loc.verify_email_error_requests,
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              context.loc.verify_email_error_generic,
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.loc.verify_email),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                Text(
                  context.loc.verify_email_view_prompt,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 24.0),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventSendEmailVerification(),
                          );
                    },
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      backgroundColor: WidgetStateProperty.all(Colors.green),
                    ),
                    child: Text(
                      context.loc.verify_email_send_email_verification,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    },
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(Colors.blue),
                    ),
                    child: Text(
                      context.loc.restart,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
