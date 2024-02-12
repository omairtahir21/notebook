import 'package:sqflite/sqflite.dart';

import '../model/checkmodel.dart';
import '../model/model_data.dart';

class DatabaseHelper {
  final String tableName = 'items';
  final String columnId = 'id';
  final String columnHeading = 'heading';
  final String columnDescription = 'description'; // Updated column name

  Database? _database;

  Future open() async {
    _database ??= await openDatabase('addNote.db', version: 1,
        onCreate: (Database db, int version) async {
      // Create the table with the description column
      await db.execute('''
        CREATE TABLE $tableName (
          $columnId INTEGER PRIMARY KEY,
          $columnHeading TEXT,
          $columnDescription TEXT  -- Add the description field
        )
      ''');
    });
  }

  Future<int> insert(AddNote item) async {
    await open();
    return await _database!.insert(
      tableName,
      item.toMap(),
    );
  }

  Future<List<AddNote>> getAllItems() async {
    await open();
    List<Map<String, dynamic>> maps = await _database!.query(tableName);
    return List.generate(maps.length, (i) {
      return AddNote.fromMap(maps[i]);
    });
  }

  Future<List<AddNote>> searchItems(String keyword) async {
    await open();
    List<Map<String, dynamic>> maps = await _database!.query(tableName,
        where: columnHeading ?? '', whereArgs: ['%$keyword%']);

    return List.generate(maps.length, (index){
      return AddNote.fromMap(maps[index]);
    });
  }

  Future<int> update(AddNote item) async {
    await open();
    return await _database!.update(
      tableName,
      item.toMap(),
      where: '$columnId = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> delete(int id) async {
    await open();
    return await _database!
        .delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> insertChecklistItem(CheckListItem item) async {
    await open();
    return await _database!.insert(tableName, item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<CheckListItem>> getCheckItemList() async {
    await open();
    List<Map<String, dynamic>> maps = await _database!.query(tableName);
    return List.generate(maps.length, (i){
      return CheckListItem.fromMap(maps[i]);
    });
  }

  Future<int> updateCheck(CheckListItem item) async {
    await open();
    return await _database!.update(
      tableName,
      item.toMap(),
      where: '$columnId = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deletcheck(int id) async {
    await open();
    return await _database!
        .delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<void> closeDatabase() async {
    await _database!.close();
  }
}
