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
  List<List<Weather>> weather_f;
  bool data = false;
  bool to_forenheit = false;

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

  Future<List<List<Weather>>> _getMockData(Position position) {
    HttpService httpService;

    httpService = HttpService(
        position.latitude.toString(), position.longitude.toString());

    setState(() {
      data = true;
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

  Widget _renderSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(this.to_forenheit ? "°F" : "°C"),
        Switch(
            value: this.to_forenheit,
            onChanged: (bool newValue) {
              setState(() {
                to_forenheit = newValue;
              });
            })
      ],
    );
  }

  _forenheitWeather(List<List<Weather>> list) {
    List<List<Weather>> foo = List();

    for (var i = 0; i < list.length; i++) {
      List<Weather> foo1 = list[i]
          .map((Weather weather) => Weather.fromWeather(weather))
          .toList();
        foo.add(foo1);
    }

    this.weather_f = foo;
  }

  @override
  Widget build(BuildContext context) {
    if (!this.data) {
      this._getCurrentLocation();
    }
    return FutureBuilder(
      future: weather,
      builder:
          (BuildContext context, AsyncSnapshot<List<List<Weather>>> snapshot) {
        if (snapshot.hasData) {
          List<List<Weather>> list = snapshot.data;
          if (this.to_forenheit) {
            if (this.weather_f == null) {
              this._forenheitWeather(snapshot.data);
            }
            list = this.weather_f;
          }
          return ListView(
            children: [this._renderSwitch(), ...this._renderCards(list)],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

/*MediaQuery.of(context).size.width * 0.75,*/
