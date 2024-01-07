import 'package:get_emg_data/foundation/response.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";
import 'package:get_emg_data/foundation/database_const.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'package:get_emg_data/util/logger.dart';
import 'package:flutter/foundation.dart';

///
/// (TODO)将来的に、FutureProviderにして、isOpenedをなくして簡単な実装にしたい。
///
final databaseProvider = ChangeNotifierProvider<DatabaseNotifier>((ref) {
  return DatabaseNotifier();
});
//final databaseProvider = Provider((_) => DatabaseClient());

class DatabaseNotifier extends ChangeNotifier {
  late Database _database;
  bool isOpened = false;

  Future<void> initialize() async {
    logger.i("database is initializing");
    final databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "database.db");

    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        for (var file in DatabaseConst.general.initialSQLs) {
          final sql = await rootBundle.loadString(file);
          await db.execute(sql);
        }
      },
      onOpen: (db) async {
        logger.i("database is opened");

        isOpened = true;
        notifyListeners();
      },
    ).then((db) => _database = db);
  }

  Future<void> insert(String table, Map<String, Object?> values) async {
    try {
      await _database.insert(table, values);
      return Future.value();
    } catch (error) {
      logger.e(error);
      return Future.error(error);
    }
  }

  Future<void> update(
      String table, Map<String, Object?> values, String where) async {
    try {
      var res = await _database.update(table, values, where: where);
      //logger.i(where);
      //logger.i(values);
      //logger.i(res);
      return Future.value();
    } catch (error) {
      logger.e(error);
      return Future.error(error);
    }
  }

  Future<List<Map<String, Object?>>> select(
    String table, {
    List<String>? columns,
    List<Foreign>? foreigns = null,
    String? where = null,
  }) async {
    var query = 'SELECT';
    if (columns != null) {
      for (final column in columns) {
        query += ' $column,';
      }
      query = query.substring(0, query.length - 1);
    } else {
      query += ' *';
    }

    query += ' FROM $table';

    if (foreigns != null) {
      for (final foreign in foreigns) {
        query +=
            ' INNER JOIN ${foreign.table} ON $table.${foreign.key} = ${foreign.table}.${foreign.key}';
      }
    }
    if (where != null) {
      query += ' WHERE $where';
    }
    //logger.i(query);
    return _database.rawQuery(query);
  }

  Future<void> delete(String table, String where) async {
    try {
      await _database.delete(table, where: where);
      return Future.value();
    } catch (error) {
      return Future.error(error);
    }
  }
}

class Foreign {
  Foreign(this.table, this.key);
  final String table;
  final String key;
}
