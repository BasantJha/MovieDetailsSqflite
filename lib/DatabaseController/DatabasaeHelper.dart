
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'MovieDetails.dart';


class ResponseBlock
{
  final void Function<T>(T data) SuccessBlock;
  final void Function<T>(T data) FailureBlock;
  ResponseBlock({required this.SuccessBlock,required this.FailureBlock});
}


class DatabaseMovieHelperData {
  static final _MovieDataBaseName = "movie.db";
  static final _databaseVersion = 1;
  static final table = 'movie_table';
  static final columnId = 'id';
  static final columnMovieName = 'moviename';
  static final columnDirectorName = 'directorName';
  static final columnPoster = 'poster';
  String? path;

  // make this a singleton class
  DatabaseMovieHelperData._privateConstructor();
  static final DatabaseMovieHelperData instance =
  DatabaseMovieHelperData._privateConstructor();
  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }


  _initDatabase() async {
    Directory directory;
    if (kIsWeb) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    String path = join(directory.path, _MovieDataBaseName);
    print(path);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnMovieName TEXT NOT NULL,
            $columnDirectorName TEXT NOT NULL,
            $columnPoster TEXT NOT NULL
          )
      ''');

  }

  insert(MovieDetails movieDetails,ResponseBlock responseBlock) async
  {
    print(movieDetails);
    Database? db = await instance.database;
    try
        {
          responseBlock.SuccessBlock(
           await db!.insert(table, {
          'moviename': movieDetails.MovieName,
          'directorName': movieDetails.DirectorName,
          'poster': movieDetails.Poster,
          })
          );
        }
        catch(e)
    {
      responseBlock.FailureBlock(0);
    }
  }


  queryAllRows(ResponseBlock responseBlock) async {
    Database? db = await instance.database;
    try
    {
      print("Inside Qurry all Data in helper class");
      var data = await db!.query(table);
      if(data.isEmpty)
        {
          responseBlock.FailureBlock(0);
        }
      else
        {
          responseBlock.SuccessBlock(data);
        }

    }
    catch(e)
    {
      responseBlock.FailureBlock(e);
    }
  }



  Future<List<Map<String, dynamic>>> queryRows(movieName) async
  {
    Database? db = await instance.database;
    return await db!.query(table, where: "$columnMovieName LIKE '%$movieName%'");
  }


  Future<int?> queryRowCount() async {
    Database? db = await instance.database;
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $table'));
  }


  update(MovieDetails user,ResponseBlock responseBlock) async
  {
    Database? db = await instance.database;
    int id = user.toMap()['id'];
    try
    {
      responseBlock.SuccessBlock(await db!.update(table, user.toMap(), where: '$columnId = ?', whereArgs: [id]));
    }
    catch(e)
    {
      responseBlock.FailureBlock(0);
    }
  }


  delete(int id,ResponseBlock responseBlock) async
  {
    Database? db = await instance.database;
    try
    {
      responseBlock.SuccessBlock(await db!.delete(table, where: '$columnId = ?', whereArgs: [id]));
    }
    catch(e)
    {
      responseBlock.FailureBlock(0);
    }

  }

}
