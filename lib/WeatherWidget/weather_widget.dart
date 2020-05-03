import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/WeatherWidget/weather_detail.dart';
import '../http_service.dart';
import './weather.dart';

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<WeatherWidget> {
  Future<List<List<Weather>>> weather;
  bool location = false;

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
          this._getMockData(position);
    }).catchError((e) {
      print(e);
    });
  }

  Future<List<List<Weather>>> _getMockData(Position position){
    HttpService httpService;

    httpService = HttpService(position.latitude.toString(),
          position.longitude.toString());

    setState(() {
      location = true;
      weather = httpService.getMockData();
    });
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
                        builder: (context) => WeatherDetail(weather),
                      ),
                    ))))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (!this.location) {
      this._getCurrentLocation();
    }
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
