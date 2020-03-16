import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:coolweatherflutter/data/model/area.dart';

const _DATABASE_NAME = "Area.db";

Future<Database> getDatabase() async =>
    openDatabase(join(await getDatabasesPath(), _DATABASE_NAME), version: 1,
        onCreate: (db, version) {
      db.execute('CREATE TABLE province(id INTEGER PRIMARY KEY, name TEXT);');
      db.execute(
          'CREATE TABLE city(id INTEGER PRIMARY KEY, name TEXT, province_id INTEGER);');
      db.execute(
          'CREATE TABLE county(id INTEGER PRIMARY KEY, name TEXT, weather_id TEXT, city_id INTEGER);');
    });

Future<List<Province>> getProvinces() async {
  final db = await getDatabase();
  final List<Map<String, dynamic>> result = await db.query('province');
  return List.generate(result.length, (i) => Province.fromJson(result[i]));
}

Future<List<City>> getCities({final int provinceId}) async {
  final db = await getDatabase();
  final List<Map<String, dynamic>> result = provinceId == null
      ? await db.query('city')
      : await db
          .query('city', where: 'province_id = ?', whereArgs: [provinceId]);
  return List.generate(result.length, (i) => City.fromJson(result[i]));
}

Future<List<County>> getCounties({final int cityId}) async {
  final db = await getDatabase();
  final List<Map<String, dynamic>> result = cityId == null
      ? await db.query('county')
      : await db.query('county', where: 'city_id = ?', whereArgs: [cityId]);
  return List.generate(result.length, (i) => County.fromJson(result[i]));
}

Future<void> insertProvinces(final List<Province> provinces) async {
  final db = await getDatabase();
  provinces.forEach((e) async => await db.insert('province', e.toJson()));
}

Future<void> insertCities(final List<City> cities) async {
  final db = await getDatabase();
  cities.forEach((e) async => await db.insert('city', e.toJson()));
}

Future<void> insertCounties(final List<County> counties) async {
  final db = await getDatabase();
  counties.forEach((e) async => await db.insert('county', e.toJson()));
}
