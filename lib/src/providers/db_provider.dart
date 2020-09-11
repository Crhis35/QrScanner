import 'dart:io';

import 'package:QrScanner/src/models/scan_model.dart';
export 'package:QrScanner/src/models/scan_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' type TEXT,'
          ' value TEXT'
          ')',
        );
      },
    );
  }

  // CREATE SCANS
  Future<int> newScanRaw(ScanModel newScan) async {
    final db = await this.database;

    final res = await db.rawInsert(
      "INSERT into Scans (id,type,value) "
      "VALUES (${newScan.id}, '${newScan.type}', '${newScan.value}' )",
    );
    return res;
  }

  Future<int> newScan(ScanModel newScan) async {
    final db = await this.database;

    final res = await db.insert('Scans', newScan.toJson());

    return res;
  }

  // GET SCANS
  Future<ScanModel> getScanId(int id) async {
    final db = await this.database;

    final res = await db.query(
      'Scans',
      where: 'id = ?',
      whereArgs: [id],
    );

    return res.isEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await this.database;
    final res = await db.query('Scans');

    List<ScanModel> list = res.isNotEmpty
        ? res.map((scan) => ScanModel.fromJson(scan)).toList()
        : [];
    return list;
  }

  Future<List<ScanModel>> getScansByType(String type) async {
    final db = await this.database;
    final res = await db.rawQuery("SELECT * FROM Scans WHERE type='$type'");

    List<ScanModel> list = res.isNotEmpty
        ? res.map((scan) => ScanModel.fromJson(scan)).toList()
        : [];
    return list;
  }

  // UPDATE SCANS
  Future<int> updateScan(ScanModel scan) async {
    final db = await this.database;

    final res = await db
        .update('Scans', scan.toJson(), where: 'id = ?', whereArgs: [scan.id]);

    return res;
  }

  // DELETE SCANS
  Future<int> deleteScan(int id) async {
    final db = await this.database;

    final res = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  // DELETE SCANS
  Future<int> deleteScanAll() async {
    final db = await this.database;

    final res = await db.rawDelete('DELETE FROM Scans');

    return res;
  }
}
