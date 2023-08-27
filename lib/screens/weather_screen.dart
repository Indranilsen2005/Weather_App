import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:weather_app/widgets/additional_information.dart';
import 'package:weather_app/widgets/hourly_forecast.dart';
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  double kelvinToCelcius(double kelvin) {
    final celcius = kelvin - 273;
    return celcius;
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=London,uk&APPID=$apiKey',
        ),
      );
      final responseData = jsonDecode(response.body);
      if (responseData['cod'] != '200') {
        throw 'An unexpected error occured!!!';
      }

      return responseData;
    } catch (e) {
      throw 'An unexpected error occured!!!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          final currentWeatherData = snapshot.data!['list'][0];
          final currentTemperature = currentWeatherData['main']['temp'];
          final currentFeelsLikeTemperature =
              currentWeatherData['main']['feels_like'];
          final currentWeatherDescription =
              currentWeatherData['weather'][0]['description'];
          final currentSky = currentWeatherData['weather'][0]['main'];

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'London',
                    style: TextStyle(fontSize: 35),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: ListTile(
                              title: Text(
                                '${kelvinToCelcius(currentTemperature).toInt()}°',
                                style: const TextStyle(
                                    fontSize: 90,
                                    fontFamily: 'Times new roman'),
                              ),
                              subtitle: Text(
                                'Feels like ${kelvinToCelcius(currentFeelsLikeTemperature).toInt()}°\n$currentWeatherDescription',
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              trailing: Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 100,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Hourly Forecast',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        final hourlyWeatherData =
                            snapshot.data!['list'][index + 1];
                        final hourlyTemperature =
                            kelvinToCelcius(hourlyWeatherData['main']['temp'])
                                .toInt();
                        final time =
                            DateTime.parse(hourlyWeatherData['dt_txt']);
                        final hourlySky =
                            hourlyWeatherData['weather'][0]['main'];

                        return HourlyForecast(
                            hour: DateFormat.j().format(time),
                            icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                            temperature: '$hourlyTemperature° C');
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Additional Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AdditionalInformation(
                          icon: Icons.water_drop,
                          title: 'Humadity',
                          value: '${currentWeatherData['main']['humidity']}%'),
                      AdditionalInformation(
                          icon: Icons.speed,
                          title: 'Wind Speed',
                          value:
                              '${currentWeatherData['wind']['speed'].toString()} km/h'),
                      AdditionalInformation(
                          icon: Icons.air,
                          title: 'Pressure',
                          value: currentWeatherData['main']['pressure']
                              .toString()),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
