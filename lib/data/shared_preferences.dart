import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:coolweatherflutter/data/model/weather.dart';

const _KEY_CITY_NAME = 'city_name';
const _KEY_WEATHER_ID = 'weather_id';
const _KEY_WEATHER = 'weather';
const _KEY_PIC_URL = 'pic_url';

Future<void> setSelectedArea(
    final String cityName, final String weatherId) async {
  final sp = await SharedPreferences.getInstance();
  await sp.setString(_KEY_CITY_NAME, cityName);
  await sp.setString(_KEY_WEATHER_ID, weatherId);
}

Future<MapEntry<String, String>> getSelectedArea() async {
  final sp = await SharedPreferences.getInstance();
  final cityName = sp.getString(_KEY_CITY_NAME);
  final weatherId = sp.getString(_KEY_WEATHER_ID);
  return MapEntry(cityName, weatherId);
}

Future<void> setWeather(final Weather weather) async =>
    await (await SharedPreferences.getInstance())
        .setString(_KEY_WEATHER, jsonEncode(weather));

Future<Weather> getWeather() async {
  final sp = await SharedPreferences.getInstance();
  final json = sp.getString(_KEY_WEATHER);
  return json == null ? null : Weather.fromJson(jsonDecode(json));
}

Future<void> setPic(final String url) async =>
    await (await SharedPreferences.getInstance()).setString(_KEY_PIC_URL, url);

Future<String> getPic() async =>
    (await SharedPreferences.getInstance()).getString(_KEY_PIC_URL);
