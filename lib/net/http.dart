import 'package:dio/dio.dart';

urlPic() => 'http://guolin.tech/api/bing_pic';
urlArea() => 'http://guolin.tech/api/china';
urlWeather(String weatherId) =>
    'http://guolin.tech/api/weather?cityid=$weatherId&key=bc0418b57b2d4918819d3974ac1285d9';

class HttpHelper {
  static final _instance = HttpHelper._internal();
  Dio dioClient;

  factory HttpHelper() => _instance;

  HttpHelper._internal() {
    if (null == dioClient) {
      dioClient = Dio();
//        ..interceptors.add(InterceptorsWrapper(
//            onRequest: (r) => print(r.uri), onResponse: (r) => print(r)));
    }
  }
}
