class WeatherData {
  final String description;
  final double temp;
  final List<dynamic> hourly;
  final List<dynamic> daily;

  WeatherData({
    required this.description,
    required this.temp,
    required this.hourly,
    required this.daily,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      description: json['current']['weather'][0]['description'],
      temp: json['current']['temp'].toDouble(),
      hourly: json['hourly'],
      daily: json['daily'],
    );
  }
}
