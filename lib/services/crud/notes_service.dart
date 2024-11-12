import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart'
    show MissingPlatformDirectoryException, getApplicationDocumentsDirectory;
import 'package:path/path.dart' show join;

class DatabaseAlreadyOpenException implements Exception {}

class UnableToGetDocumentsDirectoryException implements Exception {}

class DatabaseIsNotOpenException implements Exception {}

class CouldNotDeleteUserException implements Exception {}

class UserAlreadyExistsException implements Exception {}

class CouldNotFindUserException implements Exception {}

class CouldNotFindNoteException implements Exception {}

class CouldNotDeleteNoteException implements Exception {}

class CouldNotUpdateNoteException implements Exception {}

class NotesService {
  Database? _db;

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    final db = _getDatabaseOrThrow();

    // get note before to check if note exists, it will throw an exception if it doesn't
    await getNote(id: note.id);

    final updatesCount = await db.update(
      noteTable,
      {
        textColumn: text,
        isSyncedWithCloudColumn: 0,
      },
      // TODO: this should be added, but the tutorial doesn't mention it
      // where: '$idColumn = ?',
      // whereArgs: [note.id],
    );

    if (updatesCount == 0) throw CouldNotUpdateNoteException();

    return await getNote(id: note.id);
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();

    final notes = await db.query(
      noteTable,
    );

    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();

    final notes = await db.query(
      noteTable,
      limit: 1,
      where: '$idColumn = ?',
      whereArgs: [id],
    );

    if (notes.isEmpty) throw CouldNotFindNoteException();

    return DatabaseNote.fromRow(notes.first);
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) throw CouldNotDeleteNoteException();
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();

    final dbUser = await getUser(email: owner.email);

    if (dbUser != owner) throw CouldNotFindUserException();

    const text = '';
    final noteId = await db.insert(
      noteTable,
      {
        userIdColumn: owner.id,
        textColumn: text,
        isSyncedWithCloudColumn: 1,
      },
    );

    return DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      userTable,
      limit: 1,
      where: '$emailColumn = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) throw CouldNotFindUserException();

    return DatabaseUser.fromRow(results.first);
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
      userTable,
      limit: 1,
      where: '$emailColumn = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isNotEmpty) throw UserAlreadyExistsException();

    final userId = await db.insert(
      userTable,
      {emailColumn: email.toLowerCase()},
    );

    return DatabaseUser(
      id: userId,
      email: email,
    );
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: '$emailColumn = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount == 0) throw CouldNotDeleteUserException();
  }

  Database _getDatabaseOrThrow() {
    if (_db == null) throw DatabaseIsNotOpenException();
    return _db!;
  }

  Future<void> close() async {
    if (_db == null) throw DatabaseIsNotOpenException();
    await _db!.close();
    _db = null;
  }

  Future<void> open() async {
    if (_db != null) throw DatabaseAlreadyOpenException();

    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      db.execute(createUserTable);
      db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  const DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud = map[isSyncedWithCloudColumn] as int == 1;

  @override
  toString() =>
      'Note, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';

const noteTable = 'note';
const userTable = 'user';

const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';

const createUserTable = '''
  CREATE TABLE IF NOT EXISTS $userTable (
    $idColumn INTEGER NOT NULL,
    $emailColumn TEXT NOT NULL UNIQUE,
    PRIMARY KEY ($idColumn AUTOINCREMENT)
  );
''';

const createNoteTable = '''
  CREATE TABLE IF NOT EXISTS $noteTable (
    $idColumn INTEGER NOT NULL,
    $userIdColumn INTEGER NOT NULL,
    $textColumn TEXT,
    $isSyncedWithCloudColumn INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY ($idColumn AUTOINCREMENT),
    FOREIGN KEY ($userIdColumn) REFERENCES $userTable ($idColumn)
  );
''';
