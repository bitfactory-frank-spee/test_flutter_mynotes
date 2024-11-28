import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter_mynotes/services/cloud/cloud_note.dart';
import 'package:test_flutter_mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:test_flutter_mynotes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteAllNotes({
    required String ownerUserId,
  }) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    try {
      await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then((querySnapshot) => {
                for (final document in querySnapshot.docs)
                  {batch.delete(document.reference)}
              });

      batch.commit();
    } catch (error) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      await notes.doc(documentId).delete();
    } catch (error) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({
        textFieldName: text,
      });
    } catch (error) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({
    required String ownerUserId,
  }) =>
      notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .snapshots()
          .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));

  Future<CloudNote> createNewNote({
    required String ownerUserId,
  }) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });

    final fetchedNote = await document.get();

    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  // Singleton way of work
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
