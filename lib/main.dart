import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:test_flutter_mynotes/constants/routes.dart';
import 'package:test_flutter_mynotes/services/auth/auth_service.dart';
import 'package:test_flutter_mynotes/views/login_view.dart';
import 'package:test_flutter_mynotes/views/notes/create_update_note_view.dart';
import 'package:test_flutter_mynotes/views/notes/notes_view.dart';
import 'package:test_flutter_mynotes/views/register_view.dart';
import 'package:test_flutter_mynotes/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Test MyNotes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        newNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var user = AuthService.firebase().currentUser;
        if (user != null) {
          if (user.isEmailVerified) {
            return const NotesView();
          } else {
            return const VerifyEmailView();
          }
        } else {
          return const LoginView();
        }
      },
    );
  }
}
