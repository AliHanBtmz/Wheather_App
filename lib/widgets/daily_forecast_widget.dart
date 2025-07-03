import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyForecastWidget extends StatelessWidget {
  final List<dynamic> daily;

  DailyForecastWidget({required this.daily});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          daily.take(7).map((day) {
            final date = DateTime.fromMillisecondsSinceEpoch(day['dt'] * 1000);
            final weekday = DateFormat.EEEE('tr_TR').format(date);
            print(
              "Günlük veriler////////////////////////////////////////////////////////////////",
            );
            print("${day['weather'][0]['icon']}");

            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 15.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(weekday, style: TextStyle(fontSize: 16)),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Image.network(
                      "https://openweathermap.org/img/wn/${day['weather'][0]['icon']}@4x.png",
                      width: 45,
                    ),
                  ),
                  SizedBox(
                    width: 90,
                    child: Text(
                      "${day['temp']['min'].round()}° / ${day['temp']['max'].round()}°",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}
