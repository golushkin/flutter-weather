import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_weather_icons/flutter_weather_icons.dart';
import 'package:weather/WeatherWidget/weather_detail.dart';
import '../http_service.dart';
import './weather.dart';

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<WeatherWidget> {
  Future<List<List<Weather>>> weather;
  Future<Weather> current_weather;
  List<List<Weather>> weather_f;
  bool data = false;
  bool to_forenheit = false;

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      this._getMockData(position);
      setState(() {
        data = true;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<List<List<Weather>>> _getMockData(Position position) {
    HttpService httpService;

    httpService = HttpService(
        position.latitude.toString(), position.longitude.toString());

    setState(() {
      weather = httpService.getMockData();
    });
  }

  Widget _renderCurrentWeatherColumn(IconData icon, String text){
    return Column(
              children: <Widget>[
                Icon(icon),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Text(text),
                )
              ],
            );
  }

  Widget _renderCurrentWeatherDate(){
    return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
              child: Text("Monday", style: TextStyle(fontSize: 16),),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
              child: Text("Now", style: TextStyle(color: Colors.grey[600]),),
            ),
          ],
        );
  }

  Widget _renderCurrentWeather(AsyncSnapshot<List<List<Weather>>> snapshot) {
    return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _renderCurrentWeatherDate(),
        Center(
            child: Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 30),
          child: snapshot.data[0][0].getIcon(size: 40),
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _renderCurrentWeatherColumn(WeatherIcons.wiThermometer, "+25°"),
            _renderCurrentWeatherColumn(WeatherIcons.wiStrongWind, "6.23 m/s"),
            _renderCurrentWeatherColumn(WeatherIcons.wiHumidity, "100%"),
            _renderCurrentWeatherColumn(WeatherIcons.wiBarometer, "1022hPa"),
          ],
        )
      ],
    ));
  }

  Widget _renderWeatherForecast(AsyncSnapshot<List<List<Weather>>> snapshot) {
    if (snapshot.hasData) {
      List<List<Weather>> list = snapshot.data;
      if (this.to_forenheit) {
        if (this.weather_f == null) {
          this._forenheitWeather(snapshot.data);
        }
        list = this.weather_f;
      }
      return ListView(
        children: [
          this._renderSwitch(),
          ...this._renderCards(list)
        ],
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
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
          (BuildContext context, AsyncSnapshot<List<List<Weather>>> snapshot) =>
              this._renderWeatherForecast(snapshot),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   if (!this.data) {
  //     this._getCurrentLocation();
  //   }
  //   return FutureBuilder(
  //     future: weather,
  //     builder:
  //         (BuildContext context, AsyncSnapshot<List<List<Weather>>> snapshot) =>
  //             this._renderWeatherForecast(snapshot),
  //   );
  // }

}

/*MediaQuery.of(context).size.width * 0.75,*/
