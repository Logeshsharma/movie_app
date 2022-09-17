import 'package:movie_app/screens/home/repo/movie_list_response.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MyListDatabase {
  static final MyListDatabase instance = MyListDatabase._init();

  static Database? _database;

  MyListDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE MyList ( 
  id $idType, 
  original_title $textType,
  overview $textType,
  title $textType,
  release_date $textType,
  backdrop_path $textType,
  original_language $textType,
  poster_path $textType,
  isMyList $integerType
  )
''');
  }

  insert(Movie movie) async {
    final db = await instance.database;
    try {
      await db.insert('MyList', movie.toJson());
    } catch (e) {
      // do nothing
    }
  }

  Future<int> update(Movie movie) async {
    final db = await instance.database;

    return db.update(
      'MyList',
      movie.toJson(),
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      'MyList',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Movie>> getMovieList() async {
    final db = await instance.database;

    final result = await db.query('MyList');

    return result.map((json) => Movie.fromJson(json)).toList();
  }

  Future<List<Movie>> getMyMovieList() async {
    final db = await instance.database;

    final result =
        await db.rawQuery('SELECT * FROM MyList WHERE isMyList=?', [1]);

    return result.map((json) => Movie.fromJson(json)).toList();
  }

  // ${NoteFields.isImportant} $boolType,
  //  ${NoteFields.number} $integerType,

// Future<Note> create(Note note) async {
  //   final db = await instance.database;
  //
  //   final id = await db.insert(tableNotes, note.toJson());
  //   return note.copy(id: id);
  // }
  //
  // Future<Note> readNote(int id) async {
  //   final db = await instance.database;
  //
  //   final maps = await db.query(
  //     tableNotes,
  //     columns: NoteFields.values,
  //     where: '${NoteFields.id} = ?',
  //     whereArgs: [id],
  //   );
  //
  //   if (maps.isNotEmpty) {
  //     return Note.fromJson(maps.first);
  //   } else {
  //     throw Exception('ID $id not found');
  //   }
  // }
  //
  // Future<List<Note>> readAllNotes() async {
  //   final db = await instance.database;
  //
  //   final orderBy = '${NoteFields.time} ASC';
  //   // final result =
  //   //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');
  //
  //   final result = await db.query(tableNotes, orderBy: orderBy);
  //
  //   return result.map((json) => Note.fromJson(json)).toList();
  // }
  //
  // Future<int> update(Note note) async {
  //   final db = await instance.database;
  //
  //   return db.update(
  //     tableNotes,
  //     note.toJson(),
  //     where: '${NoteFields.id} = ?',
  //     whereArgs: [note.id],
  //   );
  // }
  //
  // Future<int> delete(int id) async {
  //   final db = await instance.database;
  //
  //   return await db.delete(
  //     tableNotes,
  //     where: '${NoteFields.id} = ?',
  //     whereArgs: [id],
  //   );
  // }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
