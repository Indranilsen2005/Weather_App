import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  const HourlyForecast({
    super.key,
    required this.hour,
    required this.iconId,
    required this.temperature,
  });

  final String hour;
  final String iconId;
  final String temperature;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 120,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              hour,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 50,
              width: 50,
              child: Image.network(
                'https://openweathermap.org/img/wn/$iconId@2x.png',
              ),
            ),
            Text(
              temperature,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
