import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_weather_icons/flutter_weather_icons.dart';
import 'http_service.dart';
import './weather.dart';

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<WeatherWidget> {
  Position _currentPosition;
  Future<List<Weather>> weather;
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

  List<Widget> _renderCards(List<Weather> data) {
    return data
        .map<Widget>((Weather weather) => Card(
            child: ListTile(
                title: Text("Tomorrow"),
                subtitle: Text("May 4th"),
                trailing: Icon(
                  WeatherIcons.wiMeteor,
                ),
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
      builder: (BuildContext context, AsyncSnapshot<List<Weather>> snapshot) {
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
