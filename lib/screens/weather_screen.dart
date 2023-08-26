import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:weather_app/widgets/additional_information.dart';
import 'package:weather_app/widgets/hourly_forecast.dart';
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  double kelvinToCelcius(double kelvin) {
    final celcius = kelvin - 273;
    return celcius;
  }

  Future getCurrentWeather() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=London,uk&APPID=$apiKey',
        ),
      );
      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          temp = responseData['list'][0]['main']['temp'];
          print(temp);
        });
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Something went wrong! ${error.toString()}');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 235,
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  '${kelvinToCelcius(temp).toInt()}° C',
                                  style: const TextStyle(fontSize: 50),
                                ),
                                const Icon(Icons.cloud, size: 70),
                                const Text(
                                  'Rain',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Weather Forecast',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    const SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          HourlyForecast(
                              hour: '03:00',
                              icon: Icons.cloud,
                              temperature: '25 C'),
                          HourlyForecast(
                              hour: '03:00',
                              icon: Icons.cloud,
                              temperature: '25 C'),
                          HourlyForecast(
                              hour: '03:00',
                              icon: Icons.cloud,
                              temperature: '25 C'),
                          HourlyForecast(
                              hour: '03:00',
                              icon: Icons.cloud,
                              temperature: '25 C'),
                          HourlyForecast(
                              hour: '03:00',
                              icon: Icons.cloud,
                              temperature: '25 C'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Additional Information',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AdditionalInformation(
                            icon: Icons.water_drop,
                            title: 'Humadity',
                            value: '82%'),
                        AdditionalInformation(
                            icon: Icons.air,
                            title: 'Wind Speed',
                            value: '123.56'),
                        AdditionalInformation(
                            icon: Icons.sunny,
                            title: 'UV Index',
                            value: '123.56'),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
