class AQICity {
  String aqi;

  String pm25;

  AQICity(this.aqi, this.pm25);

  factory AQICity.fromJson(Map<String, dynamic> json) =>
      AQICity(json['aqi'], json['pm25']);

  Map<String, dynamic> toJson() => {'aqi': aqi, 'pm25': pm25};
}

class AQI {
  AQICity city;

  AQI(this.city);

  factory AQI.fromJson(Map<String, dynamic> json) =>
      AQI(AQICity.fromJson(json['city']));

  Map<String, dynamic> toJson() => {'city': city.toJson()};
}

class Update {
  String updateTime;

  Update(this.updateTime);

  factory Update.fromJson(Map<String, dynamic> json) => Update(json['loc']);

  Map<String, dynamic> toJson() => {'loc': updateTime};
}

class Basic {
  String cityName;

  String weatherId;

  Update update;

  Basic(this.cityName, this.weatherId, this.update);

  factory Basic.fromJson(Map<String, dynamic> json) =>
      Basic(json['city'], json['id'], Update.fromJson(json['update']));

  Map<String, dynamic> toJson() =>
      {'city': cityName, 'id': weatherId, 'update': update.toJson()};
}

class Temperature {
  String max;

  String min;

  Temperature(this.max, this.min);

  factory Temperature.fromJson(Map<String, dynamic> json) =>
      Temperature(json['max'], json['min']);

  Map<String, dynamic> toJson() => {'max': max, 'min': min};
}

class More {
  String info;

  More(this.info);

  factory More.fromJson(Map<String, dynamic> json) =>
      More(json['txt_d'] ?? json['txt']);

  Map<String, dynamic> toJson() => {'txt_d': info};
}

class Forecast {
  String date;

  Temperature temperature;

  More more;

  Forecast(this.date, this.temperature, this.more);

  factory Forecast.fromJson(Map<String, dynamic> json) => Forecast(json['date'],
      Temperature.fromJson(json['tmp']), More.fromJson(json['cond']));

  Map<String, dynamic> toJson() =>
      {'date': date, 'tmp': temperature.toJson(), 'cond': more.toJson()};
}

class Now {
  String temperature;

  More more;

  Now(this.temperature, this.more);

  factory Now.fromJson(Map<String, dynamic> json) =>
      Now(json['tmp'], More.fromJson(json['cond']));

  Map<String, dynamic> toJson() => {'tmp': temperature, 'cond': more.toJson()};
}

class Comfort {
  String info;

  Comfort(this.info);

  factory Comfort.fromJson(Map<String, dynamic> json) => Comfort(json['txt']);

  Map<String, dynamic> toJson() => {'txt': info};
}

class CarWash {
  String info;

  CarWash(this.info);

  factory CarWash.fromJson(Map<String, dynamic> json) => CarWash(json['txt']);

  Map<String, dynamic> toJson() => {'txt': info};
}

class Sport {
  String info;

  Sport(this.info);

  factory Sport.fromJson(Map<String, dynamic> json) => Sport(json['txt']);

  Map<String, dynamic> toJson() => {'txt': info};
}

class Suggestion {
  Comfort comfort;

  CarWash carWash;

  Sport sport;

  Suggestion(this.comfort, this.carWash, this.sport);

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
      Comfort.fromJson(json['comf']),
      CarWash.fromJson(json['cw']),
      Sport.fromJson(json['sport']));

  Map<String, dynamic> toJson() => {
        'comf': comfort.toJson(),
        'cw': carWash.toJson(),
        'sport': sport.toJson()
      };
}

class Weather {
  String status;

  Basic basic;

  AQI aqi;

  Now now;

  Suggestion suggestion;

  List<Forecast> forecastList;

  Weather(this.status, this.basic, this.aqi, this.now, this.suggestion,
      this.forecastList);

  factory Weather.fromJson(Map<String, dynamic> json) {
    List<dynamic> forecasts = json['daily_forecast'];
    return Weather(
        json['status'],
        Basic.fromJson(json['basic']),
        AQI.fromJson(json['aqi']),
        Now.fromJson(json['now']),
        Suggestion.fromJson(json['suggestion']),
        List.generate(
            forecasts.length, (index) => Forecast.fromJson(forecasts[index])));
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'basic': basic.toJson(),
        'aqi': aqi.toJson(),
        'now': now.toJson(),
        'suggestion': suggestion.toJson(),
        'daily_forecast': forecastList
      };
}
