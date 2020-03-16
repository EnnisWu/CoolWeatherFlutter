import 'dart:io';

import 'package:flutter/material.dart';
import 'package:coolweatherflutter/data/database.dart';
import 'package:coolweatherflutter/data/model/area.dart';
import 'package:coolweatherflutter/data/shared_preferences.dart';
import 'package:coolweatherflutter/net/http.dart';

enum _AreaLevel {
  _levelProvince,
  _levelCity,
  _levelCounty,
}

class ChooseAreaWidget extends StatefulWidget {
  final _level;

  ChooseAreaWidget([this._level = _AreaLevel._levelProvince]);

  @override
  State createState() => _ChooseAreaState();
}

class _ChooseAreaState extends State<ChooseAreaWidget> {
  static Province _selectedProvince;
  static City _selectedCity;
  static County _selectedCounty;
  var _title;
  List<Area> _data = [];

  @override
  void initState() {
    super.initState();
    if (widget._level == _AreaLevel._levelCity) {
      _title = _selectedProvince.name;
      _queryCities();
    } else if (widget._level == _AreaLevel._levelCounty) {
      _title = _selectedCity.name;
      _queryCounties();
    } else {
      _title = '中国';
      _queryProvinces();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemCount: _data.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) => Ink(
            color: Colors.white,
            child: ListTile(
              title: Text(_data[index].name),
              onTap: () => _onConfirm(_data[index]),
            ),
          ),
        ),
      );

  Future<void> _onConfirm(Area area) async {
    if (widget._level == _AreaLevel._levelProvince) {
      _selectedProvince = area as Province;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChooseAreaWidget(_AreaLevel._levelCity)));
    } else if (widget._level == _AreaLevel._levelCity) {
      _selectedCity = area as City;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChooseAreaWidget(_AreaLevel._levelCounty)));
    } else {
      _selectedCounty = area as County;
      await setSelectedArea(_selectedCounty.name, _selectedCounty.weatherId);
      Navigator.popUntil(context, ModalRoute.withName('/'));
    }
  }

  Future<void> _queryProvinces() async {
    final list = await getProvinces();
    if (list == null || list.isEmpty) {
      final response = await HttpHelper().dioClient.get(urlArea());
      if (response.statusCode == HttpStatus.ok && mounted) {
        List<dynamic> result = response.data;
        List<Province> provinces = List.generate(
            result.length, (index) => Province.fromJson(result[index]));
        setState(() => _data = provinces);
        insertProvinces(provinces);
      }
    } else if (mounted) {
      setState(() => _data = list);
    }
  }

  Future<void> _queryCities() async {
    final list = await getCities(provinceId: _selectedProvince.id);
    if (list == null || list.isEmpty) {
      final response = await HttpHelper()
          .dioClient
          .get('${urlArea()}/${_selectedProvince.id}');
      if (response.statusCode == HttpStatus.ok && mounted) {
        List<dynamic> result = response.data;
        List<City> cities = List.generate(
            result.length, (index) => City.fromJson(result[index]));
        setState(() => _data = cities);
        cities.forEach((e) => e.provinceId = _selectedProvince.id);
        insertCities(cities);
      }
    } else if (mounted) {
      setState(() => _data = list);
    }
  }

  Future<void> _queryCounties() async {
    final list = await getCounties(cityId: _selectedCity.id);
    if (list == null || list.isEmpty) {
      final response = await HttpHelper()
          .dioClient
          .get('${urlArea()}/${_selectedProvince.id}/${_selectedCity.id}');
      if (response.statusCode == HttpStatus.ok && mounted) {
        List<dynamic> result = response.data;
        List<County> counties = List.generate(
            result.length, (index) => County.fromJson(result[index]));
        setState(() => _data = counties);
        counties.forEach((e) => e.cityId = _selectedCity.id);
        insertCounties(counties);
      }
    } else if (mounted) {
      setState(() => _data = list);
    }
  }
}
