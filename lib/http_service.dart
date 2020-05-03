import 'package:http/http.dart' as http;
import 'dart:convert';
import 'WeatherWidget/weather.dart';

class HttpService{
  final String longitude;
  final String latitude;
  final String appId = "9036e4786a1201c63b03128892c31c1b";
  final String _base_url = "https://api.openweathermap.org/data/2.5/";
  final String _url_for_current_weather = "";
  final String _url_mock = "https://samples.openweathermap.org/data/2.5/forecast?lat=35&lon=139&appid=439d4b804bc8187953eb36d2a8c26a02";

  HttpService(this.latitude, this.longitude);

  DateTime _parseDate(Map<String, dynamic> obj){
      return DateTime.parse(obj['dt_txt']);
  }

  int _findIndex(Map<String, dynamic> body){
    for (var i = 0; i < body['list'].length; i++) {
      if (_parseDate(body['list'][i]).hour == 0) {
        return i;
      }
    }
    return 0;
  }

  Future<List<List<Weather>>> getMockData() async {
    http.Response res = await http.get(this._url_mock);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);
      List<List<Weather>> weathers = List();
      List<Weather> list = List();
      int counter = 0;

      for (var i = _findIndex(body); i < body['list'].length; i++) {
        if (counter > 7) {
          counter = 0;
          weathers.add(list);
          list = List();
        }
        list.add(Weather.fromJson(body['list'][i]));
        counter++;
      }

      return weathers;
    } else {
      throw "Can't get posts.";
    }
  }

  Future<List<List<Weather>>> getForecast() async {
    String url = this._base_url + "forecast?units=metric&lat=${this.latitude}&lon=${this.longitude}&appid=${this.appId}";
    http.Response res = await http.get(url);

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);
      List<List<Weather>> weathers = List();
      List<Weather> list = List();
      int counter = 0;

      for (var i = _findIndex(body); i < body['list'].length; i++) {
        if (counter > 7) {
          counter = 0;
          weathers.add(list);
          list = List();
        }
        list.add(Weather.fromJson(body['list'][i]));
        counter++;
      }

      return weathers;
    } else {
      throw "Can't get posts.";
    }
  }
}