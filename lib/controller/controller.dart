import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/data.dart';
import 'package:todo_app/model/note_model.dart';

class DatabaseHandler {
  static DatabaseHandler? instance = DatabaseHandler._init();

  DatabaseHandler._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _openDB();
    return _database!;
  }

  Future<Database> _openDB() async {
    String path = join(await getDatabasesPath(), 'NoteDatabase.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    db.execute('''
    CREATE LIST $noteList(
    $colId $idType,
    $colTitle $textType,
    $colDescription $textType
    
    )
    
    ''');
  }

//create
  Future<void> createNote(noteModel) async {
    final Database db = await instance!.database;
    await db.insert(noteList,
        noteModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

//update
  Future<void> updateNote(noteModel) async {
    final Database db = await instance!.database;
    await db.update(noteList, noteModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
        where: '$colId = ?',
        whereArgs: [noteModel.id]);
  }

  //delete
  Future<void> deleteNote(noteModel) async {
    final Database db = await instance!.database;
    await db.delete(noteList, where: '$colId =?', whereArgs: [noteModel.id]);
  }

// show all notes
  Future<List<NoteModel>> getAllNotes() async {
    final Database db = await instance!.database;
    List<Map<String, dynamic>> maps = await db.query(noteList);
    return maps.isNotEmpty
        ? maps.map((note) => NoteModel.fromMap(note)).toList()
        : [];
  }

  //get Note
  Future<List> getOneNote(int id) async {
    final Database db = await instance!.database;
    List<Map<String, dynamic>> maps =
        await db.query(noteList, where: '$colId =?', whereArgs: [id]);
    return maps.isNotEmpty ? maps.map((note) => NoteModel.fromMap(note)).toList():[];
  }
}
