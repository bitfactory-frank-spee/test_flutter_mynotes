import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_mynotes/constants/routes.dart';
import 'package:test_flutter_mynotes/enums/menu_action.dart';
import 'package:test_flutter_mynotes/extensions/buildcontext/loc.dart';
import 'package:test_flutter_mynotes/services/auth/auth_service.dart';
import 'package:test_flutter_mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:test_flutter_mynotes/services/auth/bloc/auth_event.dart';
import 'package:test_flutter_mynotes/services/cloud/cloud_note.dart';
import 'package:test_flutter_mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:test_flutter_mynotes/utilities/dialogs/delete_dialog.dart';
import 'package:test_flutter_mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:test_flutter_mynotes/views/notes/notes_list_view.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Image(
            image: AssetImage('assets/bitfactory-logo-black.png'),
          ),
        ),
        title: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId).getLength,
          builder: (context, AsyncSnapshot<int> snapshot) {
            if (snapshot.hasData) {
              final noteCount = snapshot.data ?? 0;
              return Text(
                context.loc.notes_title(noteCount),
              );
            } else {
              return const Text('');
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.deleteAllNotes:
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  await _notesService.deleteAllNotes(ownerUserId: userId);
                }
                break;
              case MenuAction.logout:
                final shouldLogout = await showLogOutDialog(context);
                if (shouldLogout) {
                  if (context.mounted) {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  }
                }
            }
          }, itemBuilder: (context) {
            return [
              PopupMenuItem<MenuAction>(
                value: MenuAction.deleteAllNotes,
                child: Text(
                  context.loc.delete_all_notes,
                ),
              ),
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text(
                  context.loc.logout_button,
                ),
              ),
            ];
          }),
        ],
      ),
      body: StreamBuilder(
          stream: _notesService.allNotes(ownerUserId: userId),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.active:
                if (snapshot.hasData) {
                  final allNotes = snapshot.data as Iterable<CloudNote>;
                  return SafeArea(
                    child: NotesListView(
                      notes: allNotes,
                      onDeleteNote: (note) async {
                        await _notesService.deleteNote(
                          documentId: note.documentId,
                        );
                      },
                      onTap: (note) async {
                        Navigator.of(context).pushNamed(
                          createOrUpdateNoteRoute,
                          arguments: note,
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          }),
    );
  }
}
