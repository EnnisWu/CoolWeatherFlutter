import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coolweatherflutter/route/choose_area.dart';
import 'package:coolweatherflutter/route/weather.dart';

void main() {
  runApp(MyApp());

  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => WeatherWidget(),
        '/choose_area': (context) => ChooseAreaWidget(),
      },
      debugShowCheckedModeBanner: false,
      title: 'The Weather',
      theme: ThemeData(primaryColor: Colors.white),
    );
  }
}
