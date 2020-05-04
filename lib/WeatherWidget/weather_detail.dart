import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_weather_icons/flutter_weather_icons.dart';
import 'package:weather/WeatherWidget/weather.dart';
import '../strings.dart';

class WeatherDetail extends StatelessWidget {
  final List<Weather> weathers;

  WeatherDetail(this.weathers);

  Widget _renderCard(
      BuildContext context, List<Widget> children, Widget header) {
    return Card(
        child: Column(
      children: <Widget>[
        header != null ? header : SizedBox.shrink(),
        Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.12,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: children.length,
                  itemBuilder: (BuildContext cotext, int index) => Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: children[index],
                      )),
            )),
      ],
    ));
  }

  Widget _renderWeatherCard(BuildContext context) {
    return this._renderCard(
        context,
        this
            .weathers
            .map<Widget>((Weather weather) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(weather.getTime()),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: weather.getIcon()),
                    Text(weather.getTemperature()),
                  ],
                ))
            .toList(),
        null);
  }

  Widget _renderWindCard(BuildContext context) {
    return this._renderCard(
        context,
        this
            .weathers
            .map<Widget>((Weather weather) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(weather.getTime()),
                    Text(weather.getWind()),
                  ],
                ))
            .toList(),
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
              child: Icon(WeatherIcons.wiStrongWind),
            ),
            Text(
              weather_cond[ui.window.locale.languageCode]['wind'],
            )
          ],
        ));
  }

  Widget _renderHumidityCard(BuildContext context) {
    return this._renderCard(
        context,
        this
            .weathers
            .map<Widget>((Weather weather) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(weather.getTime()),
                    Text(weather.getHumidity()),
                  ],
                ))
            .toList(),
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
              child: Icon(WeatherIcons.wiHumidity),
            ),
            Text(
              weather_cond[ui.window.locale.languageCode]['hum'],
            )
          ],
        ));
  }

  Widget _renderPressureCard(BuildContext context) {
    return this._renderCard(
        context,
        this
            .weathers
            .map<Widget>((Weather weather) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(weather.getTime()),
                    Text(weather.getPressure()),
                  ],
                ))
            .toList(),
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
              child: Icon(WeatherIcons.wiBarometer),
            ),
            Text(
              weather_cond[ui.window.locale.languageCode]['pres'],
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(weathers[0].getDayOfWeek()),
      ),
      body: Column(
        children: <Widget>[
          this._renderWeatherCard(context),
          this._renderWindCard(context),
          this._renderHumidityCard(context),
          this._renderPressureCard(context)
        ],
      ),
    );
  }
}
