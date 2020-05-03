import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../strings.dart';

final String language = ui.window.locale.languageCode;

class Weather {
  double temperature;
  int pressure;
  int weather_id;
  double wind_speed;
  int humidity;
  DateTime date;

  Weather({
    this.temperature,
    this.pressure,
    this.weather_id,
    this.humidity,
    this.wind_speed,
    this.date,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        temperature: json['main']['temp'],
        pressure: json['main']['pressure'].floor(),
        weather_id: json['weather'][0]['id'],
        wind_speed: json['wind']['speed'],
        humidity: json['main']['humidity'],
        date: DateTime.parse(json['dt_txt']));
  }

  String getDayOfWeek() {
    return strings[language]['dof'][this.date.weekday - 1];
  }

  String getMonthPday() {
    String data;
    if (language == "en") {
      data = strings[language]['months'][this.date.month - 1];
      data += " " + this.date.day.toString() + "th";
    } else {
      data = strings[language]['months'][this.date.month - 1];
      data += ", " + this.date.day.toString();
    }
    return data;
  }

  Icon getIcon(){
    String part_of_day;
    if (this.date.hour <= 18) {
      part_of_day = "day";
    }
    else{
      part_of_day = 'night';
    }
    return Icon(icons[part_of_day][this.weather_id]);
  }

  String getTime(){
    return "${this.date.hour}:00";
  }

  String getTemperature(){
    return "+${this.temperature}°";
  }

  String getWind(){
    return "${this.wind_speed}\nm/s";
  }

   String getHumidity(){
    return "${this.humidity}%";
  }

   String getPressure(){
    return "${this.pressure}hPa";
  }
}
