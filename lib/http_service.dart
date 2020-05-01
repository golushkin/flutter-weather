import 'package:http/http.dart' as http;
import 'dart:convert';
import './weather.dart';

class HttpService{
  final String longitude;
  final String latitude;
  final String _base_url = "";
  final String _url_for_current_weather = "";
  final String _url_for_5_day = "https://api.openweathermap.org/data/2.5/forecast?units=metric&lat={lat}&lon={lon}&appid={your api key}";
  final String _url_mock = "https://samples.openweathermap.org/data/2.5/forecast?lat=35&lon=139&appid=439d4b804bc8187953eb36d2a8c26a02";

  HttpService(this.latitude, this.longitude);

  Future<List<Weather>> getMockData() async {
    http.Response res = await http.get(this._url_mock);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

      List<Weather> weathers = body['list']
          .map<Weather>(
            (dynamic item) => Weather.fromJson(item),
          )
          .toList();

      return weathers;
    } else {
      throw "Can't get posts.";
    }
  }
}