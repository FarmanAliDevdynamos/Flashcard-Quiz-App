import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quiz.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String path = join(await getDatabasesPath(), filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE questions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question TEXT,
        answer TEXT,
        cardId INTEGER
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> getQuestionsByCardId(int cardId) async {
    final db = await database;
    return await db
        .query('questions', where: 'cardId = ?', whereArgs: [cardId]);
  }

  Future<void> insertQuestion(Map<String, dynamic> question) async {
    final db = await database;
    await db.insert('questions', question);
  }

  Future<void> updateQuestion(int id, Map<String, dynamic> question) async {
    final db = await database;
    await db.update('questions', question, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteQuestion(int id) async {
    final db = await database;
    await db.delete('questions', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllQuestions() async {
    final db = await database;
    return await db.query('questions');
  }

  Future<List<String>> getAllAnswersExcept(String correctAnswer) async {
    final db = await database;
    final List<Map<String, dynamic>> allQuestions = await db.query('questions');

    // Extracting answers from all questions
    List<String> allAnswers =
        allQuestions.map((q) => q['answer'] as String).toList();

    // Exclude the correct answer
    allAnswers.remove(correctAnswer);

    return allAnswers;
  }
}
