import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/weather_service.dart';
import '../models/weather_model.dart';
import '../widgets/hourly_forecast_widget.dart';
import '../widgets/daily_forecast_widget.dart';
import 'city_selection_screen.dart';

class WeatherScreen extends StatefulWidget {
  final String cityName;

  WeatherScreen({required this.cityName});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

String toTitleCase(String text) {
  return text
      .split(" ")
      .map(
        (word) =>
            word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                : "",
      )
      .join(" ");
}

class _WeatherScreenState extends State<WeatherScreen> {
  final weatherService = WeatherService();
  late Future<WeatherData> futureWeather;

  @override
  void initState() {
    super.initState();
    futureWeather = weatherService.fetchWeather(widget.cityName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFc3e4f3),
      appBar: AppBar(
        backgroundColor: Color(0xFF253949),
        foregroundColor: Colors.white,
        title: Text("${widget.cityName} Hava Durumu"),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assests/images/header.png', fit: BoxFit.contain),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: CircleAvatar(
                  backgroundColor: Color(0xFF253949), // Kırmızı daire
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white, // Beyaz ok
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            CitySelectionScreen(onCitySelected: (city) {}),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: FutureBuilder<WeatherData>(
        future: futureWeather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata oluştu"));
          } else {
            final weather = snapshot.data!;
            print(
              "burasını bak///////////////////////////////////////////////",
            );
            print(weather.daily[0]["weather"][0]['icon']);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 1.0),

                    // padding: const EdgeInsets.symmetric(vertical: 20.0,),
                    child: Column(
                      children: [
                        ClipRect(
                          child: Align(
                            alignment: Alignment.center,
                            heightFactor: 0.7, // daha az olursa daha çok kırpar
                            child: Image.network(
                              "http://openweathermap.org/img/wn/${weather.hourly[0]["weather"][0]['icon']}@4x.png",
                              width: 200
                              ,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        Text(
                          widget.cityName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          toTitleCase(weather.description),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),

                        Text(
                          "${(weather.temp).toInt()}°",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 15.0,
                            top: 20.0,
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${DateFormat.EEEE('tr_TR').format(DateTime.now())} BUGÜN",
                                style: TextStyle(fontSize: 16),
                              ),

                              Text(
                                "${weather.daily[0]['temp']['max'].round()}° / ${weather.daily[0]['temp']['min'].round()}°",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.black, thickness: 2),

                  HourlyForecastWidget(hourly: weather.hourly),

                  Divider(color: Colors.black, thickness: 2),

                  DailyForecastWidget(daily: weather.daily),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
