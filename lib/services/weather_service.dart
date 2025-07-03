import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  final String apiKey = "723e6550cf27d273da5260fd0944cef7";

  Future<Map<String, dynamic>> getCoordinates(String cityName) async {
    final geoUrl = Uri.parse(
      "https://api.openweathermap.org/geo/1.0/direct?q=$cityName&limit=1&appid=$apiKey",
    );
    final response = await http.get(geoUrl);
    final data = jsonDecode(response.body);
    print(
      "long lat değerleri geliyor mu bu bak//////////////////////////////////////////////////////////////////////",
    );
    print({'lat': data[0]['lat'], 'lon': data[0]['lon']});
    return {'lat': data[0]['lat'], 'lon': data[0]['lon']};
  }

  Future<WeatherData> fetchWeather(String cityName) async {
    final coords = await getCoordinates(cityName);
    final lat = coords['lat'];
    final lon = coords['lon'];

    final url = Uri.parse(
      "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=tr",
    );

    final response = await http.get(url);
    print(response);
    if (response.statusCode == 200) {
      // Yanıt başarılı ise, veriyi WeatherData modeline dönüştürüp döndürüyoruz
      print(
        "/////////////////////////////////////////////////////////////////////////////////",
      );
      print(jsonDecode(response.body));
      return WeatherData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Hava durumu verisi alınamadı");
    }
  }
}
