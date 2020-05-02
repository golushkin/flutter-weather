import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_weather_icons/flutter_weather_icons.dart';
import 'http_service.dart';
import './weather.dart';
import './strings.dart';

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<WeatherWidget> {
  Position _currentPosition;
  Future<List<List<Weather>>> weather;
  HttpService httpService;

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getForecast() {
    this._getCurrentLocation();
    httpService = HttpService('1', '1');
    return httpService.getMockData();
  }

  List<Widget> _renderCards(List<List<Weather>> data) {
    return data
        .map<Widget>((List<Weather> weather) => Card(
            child: ListTile(
                title: Text(weather[0].getDayOfWeek()),
                subtitle: Text(weather[0].getMonthPday()),
                trailing: weather[5].getIcon(),
                onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          // builder: (context) => PostDetail(
                          //   post: post,
                          // ),
                          ),
                    ))))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    weather = this._getForecast();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: weather,
      builder:
          (BuildContext context, AsyncSnapshot<List<List<Weather>>> snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: this._renderCards(snapshot.data),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

/*MediaQuery.of(context).size.width * 0.75,*/
