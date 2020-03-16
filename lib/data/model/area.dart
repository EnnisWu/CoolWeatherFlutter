class Area {
  int id;

  String name;
}

class Province implements Area {
  int id;

  String name;

  Province({this.id, this.name});

  factory Province.fromJson(Map<String, dynamic> json) =>
      Province(id: json['id'], name: json['name']);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

class City implements Area {
  int id;

  String name;

  int provinceId;

  City({this.id, this.name, this.provinceId});

  factory City.fromJson(Map<String, dynamic> json) =>
      City(id: json['id'], name: json['name'], provinceId: json['province_id']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'province_id': provinceId};
}

class County implements Area {
  int id;

  String name;

  int cityId;

  String weatherId;

  County({this.id, this.name, this.cityId, this.weatherId});

  factory County.fromJson(Map<String, dynamic> json) => County(
      id: json['id'],
      name: json['name'],
      cityId: json['city_id'],
      weatherId: json['weather_id']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'city_id': cityId, 'weather_id': weatherId};
}
