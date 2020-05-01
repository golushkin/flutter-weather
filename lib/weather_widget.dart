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

  _getForecast(){
    httpService = HttpService('1','1');
    return httpService.getMockData();
  }

  @override
  void initState() {
    super.initState();
    weather = this._getForecast();
  }

  @override
  Widget build(BuildContext context) {    

    return ListView(
      children: <Widget>[
        Card(
          child:ListTile(
          leading: Text("1.1"),
          title: Text("23°C"),
          trailing: Icon(Icons.wb_sunny),
        )
        )
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {    
  //   return FutureBuilder(
  //     future: weather,
  //     builder: (BuildContext context, AsyncSnapshot<List<Weather>> snapshot) {
  //         if (snapshot.hasData) {
  //           return ListView(
  //             children: snapshot.data
  //                 .map<Widget>(
  //                   (Weather weather) => ListTile(
  //                     title: Text(weather.temperature.toString()),
  //                     subtitle: Text("${1}"),
  //                     onTap: () => Navigator.of(context).push(
  //                       MaterialPageRoute(
  //                         // builder: (context) => PostDetail(
  //                         //   post: post,
  //                         // ),
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //                 .toList(),
  //           );
  //         } else {
  //           return Center(child: CircularProgressIndicator());
  //         }
  //       },
  //   );
  // }
}
