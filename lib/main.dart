import 'package:flutter/material.dart';
import 'package:weather/WeatherWidget/weather_widget.dart';

void main(){
  return runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text("Weather app"),
      ),
      body: WeatherWidget(),
      ),
    ),
  );
}