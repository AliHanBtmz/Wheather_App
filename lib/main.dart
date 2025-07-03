import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/city_selection_screen.dart';
import 'screens/weather_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? selectedCity;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hava Durumu',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: selectedCity == null
          ? CitySelectionScreen(
        onCitySelected: (city) {
          setState(() {
            selectedCity = city;
          });
        },
      )
          : WeatherScreen(cityName: selectedCity!),
    );
  }
}
