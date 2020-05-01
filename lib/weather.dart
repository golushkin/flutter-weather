class Weather{
  double temperature;
  double pressure;
  int weather_id;
  double wind_speed;
  int humidity;

  Weather(
    {
      this.temperature,
      this.pressure,
      this.weather_id,
      this.humidity,
      this.wind_speed,
    }
  );

  factory Weather.fromJson(Map<String, dynamic> json){
    return Weather(
      temperature: json['main']['temp'],
      pressure: json['main']['pressure'],
      weather_id: json['weather'][0]['id'],
      wind_speed: json['wind']['speed'],
      humidity: json['main']['humidity'],
    );
  }
}