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
  bool data = false;
  bool to_forenheit = false;

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      this._getWeather(position);
      setState(() {
        data = true;
      });
    }).catchError((e) {
      print(e);
    });
  }

  Future<List<List<Weather>>> _getWeather(Position position) {
    HttpService httpService;

    httpService = HttpService(
        position.latitude.toString(), position.longitude.toString());

    setState(() {
      current_weather = httpService.getCurrentWeather(test: false);
      weather = httpService.getForecast(test: false);
    });
  }

  Widget _renderCurrentWeatherColumn(IconData icon, String text) {
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

  Widget _renderCurrentWeatherDate(AsyncSnapshot<Weather> snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
          child: Text(
            snapshot.data.getDayOfWeek(),
            style: TextStyle(fontSize: 16),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
          child: Text(
            snapshot.data.getMonthPday(),
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _renderCurrentWeather(AsyncSnapshot<Weather> snapshot,
      AsyncSnapshot<List<List<Weather>>> snapshotForecast) {
    if (snapshot.hasData) {
      return Column(
        children: <Widget>[
          this._renderSwitch(),
          Card(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _renderCurrentWeatherDate(snapshot),
              Center(
                  child: Container(
                padding: EdgeInsets.fromLTRB(0, 5, 0, 30),
                child: snapshot.data.getIcon(size: 40),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _renderCurrentWeatherColumn(
                      WeatherIcons.wiThermometer,
                      this.to_forenheit
                          ? snapshot.data.getTemperatureForen()
                          : snapshot.data.getTemperature()),
                  _renderCurrentWeatherColumn(
                      WeatherIcons.wiStrongWind, snapshot.data.getWind()),
                  _renderCurrentWeatherColumn(
                      WeatherIcons.wiHumidity, snapshot.data.getHumidity()),
                  _renderCurrentWeatherColumn(
                      WeatherIcons.wiBarometer, snapshot.data.getPressure()),
                ],
              )
            ],
          )),
          this._renderWeatherForecast(snapshotForecast)
        ],
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _renderWeatherForecast(AsyncSnapshot<List<List<Weather>>> snapshot) {
    if (snapshot.hasData) {
      return Column(
        children: <Widget>[...this._renderCards(snapshot.data)],
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
                        builder: (context) =>
                            WeatherDetail(weather, this.to_forenheit),
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

  @override
  Widget build(BuildContext context) {
    if (!this.data) {
      this._getCurrentLocation();
    }

    return FutureBuilder(
        future: current_weather,
        builder: (BuildContext context, AsyncSnapshot<Weather> snapshot) {
          return FutureBuilder(
              future: weather,
              builder: (BuildContext context,
                  AsyncSnapshot<List<List<Weather>>> snapshotForecast) {
                return this._renderCurrentWeather(snapshot, snapshotForecast);
              });
        });
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
