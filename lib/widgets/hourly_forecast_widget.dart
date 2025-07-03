import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HourlyForecastWidget extends StatelessWidget {
  final List<dynamic> hourly;

  HourlyForecastWidget({required this.hourly});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        itemBuilder: (context, index) {
          final hour = hourly[index];
          final time = DateFormat.Hm().format(
            DateTime.fromMillisecondsSinceEpoch(hour['dt'] * 1000),
          );
          print("///////////////////////////////////////////////");
          print("${hour['weather'][0]['icon']}");
          return Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 1.0),
            // padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  index == 0 ? "Şu An" : time,
                  style: TextStyle(fontSize: 15),
                ),

                Image.network(
                  "http://openweathermap.org/img/wn/${hour['weather'][0]['icon']}@4x.png",
                  width: 50,
                ),
                Text(
                  "${hour['temp'].round()}°",
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
