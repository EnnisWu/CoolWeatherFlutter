import 'dart:io';

import 'package:flutter/material.dart';
import 'package:coolweatherflutter/data/model/weather.dart';
import 'package:coolweatherflutter/data/shared_preferences.dart';
import 'package:coolweatherflutter/net/http.dart';
import 'package:coolweatherflutter/route/choose_area.dart';

class WeatherWidget extends StatefulWidget {
  @override
  State createState() => _WeatherState();
}

class _WeatherState extends State<WeatherWidget> {
  String _picURL;
  String _cityName;
  String _weatherId;
  Weather _weather;

  @override
  void initState() {
    super.initState();
    _initData(false);
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        onRefresh: () async {
          await _refreshWeather();
          await _refreshPic();
        },
        child: Stack(
          children: <Widget>[
            ConstrainedBox(
              constraints: const BoxConstraints.expand(),
              child: _picURL == null
                  ? Image.asset('images/background.jpg')
                  : Image.network(_picURL, fit: BoxFit.cover),
            ),
            ListView(
              physics: const BouncingScrollPhysics(),
              children: <Widget>[
                _buildNow(),
                _buildForecast(),
                _buildAqi(),
                _buildSuggestion()
              ],
            )
          ],
        ),
      );

  Widget _buildNow() => Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Text(
                '${_weather?.now?.temperature}℃',
                style: _textStyle(60),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () => _requireChooseArea(),
                      child: Text(
                        _cityName ?? '',
                        style: _textStyle(20),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      _weather?.now?.more?.info ?? '',
                      style: _textStyle(20),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );

  Widget _buildForecast() {
    List<Widget> forecasts = [
      Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            '预报',
            style: _textStyle(20),
          ),
        ),
      )
    ];
    _weather?.forecastList?.forEach((forecast) {
      forecasts.add(Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Text(forecast?.date ?? '', style: _textStyle(14))),
            Expanded(
                flex: 1,
                child: Text(forecast?.more?.info ?? '',
                    textAlign: TextAlign.center, style: _textStyle(14))),
            Expanded(
                flex: 1,
                child: Text(forecast?.temperature?.max ?? '',
                    textAlign: TextAlign.right, style: _textStyle(14))),
            Expanded(
                flex: 1,
                child: Text(forecast?.temperature?.min ?? '',
                    textAlign: TextAlign.right, style: _textStyle(14)))
          ],
        ),
      ));
    });
    return Container(
      margin: const EdgeInsets.all(15),
      color: _boxColor(),
      child: Column(children: forecasts),
    );
  }

  Widget _buildAqi() => Container(
        margin: const EdgeInsets.all(15),
        color: _boxColor(),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '空气质量',
                  style: _textStyle(20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(_weather?.aqi?.city?.aqi ?? '',
                            style: _textStyle(40)),
                        Text('AQI指数', style: _textStyle(14))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(_weather?.aqi?.city?.pm25 ?? '',
                            style: _textStyle(40)),
                        Text('PM2.5指数', style: _textStyle(14))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildSuggestion() => Container(
        margin: const EdgeInsets.all(15),
        color: _boxColor(),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '生活建议',
                  style: _textStyle(20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                '舒适度：${_weather?.suggestion?.comfort?.info}',
                style: _textStyle(15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                '洗车指数：${_weather?.suggestion?.carWash?.info}',
                style: _textStyle(15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(
                '运行建议：${_weather?.suggestion?.sport?.info}',
                style: _textStyle(15),
              ),
            )
          ],
        ),
      );

  Future<void> _initData(bool isDirty) async {
    final MapEntry<String, String> area = await getSelectedArea();
    _cityName = area.key;
    _weatherId = area.value;
    if (_cityName == null ||
        _cityName.isEmpty ||
        _weatherId == null ||
        _weatherId.isEmpty) {
      _requireChooseArea();
    } else if (mounted) {
      if (isDirty) {
        _refreshWeather();
        _refreshPic();
      } else {
        _queryData();
      }
    }
  }

  Future<void> _requireChooseArea() async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChooseAreaWidget()));
    _initData(true);
  }

  Future<void> _queryData() async {
    final url = await getPic();
    if (url == null || url.isEmpty) {
      _refreshPic();
    } else if (mounted) {
      setState(() => _picURL = url);
    }
    final weather = await getWeather();
    if (weather == null) {
      _refreshWeather();
    } else if (mounted) {
      setState(() => _weather = weather);
    }
  }

  Future<void> _refreshWeather() async {
    final response = await HttpHelper().dioClient.get(urlWeather(_weatherId));
    if (response.statusCode == HttpStatus.ok && mounted) {
      setWeather(_weather);
      setState(
          () => _weather = Weather.fromJson(response.data['HeWeather'][0]));
    }
  }

  Future<void> _refreshPic() async {
    final response = await HttpHelper().dioClient.get(urlPic());
    if (response.statusCode == HttpStatus.ok && mounted) {
      setPic(_picURL);
      setState(() => _picURL = response.data);
    }
  }

  _boxColor() => const Color(0x88000000);

  _textStyle(final double fontSize) => TextStyle(
      fontSize: fontSize, color: Colors.white, decoration: TextDecoration.none);
}
