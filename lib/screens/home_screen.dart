import 'package:app_weather/provider/weather_provider.dart';
import 'package:app_weather/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cityName = TextEditingController(text: 'hanoi');

  /* @override
  @override
  void initState() {
    super.initState();
    if (widget.initialWeather != null) {
      _futureWeather = Future.value(widget.initialWeather);
    } else {
      _futureWeather = _weather.fechWeather(_cityName.text.trim());
    }
  } */

  void _seach() {
    final city = _cityName.text.trim();
    if (city.isEmpty) {
      context.read<WeatherProvider>().fectWeatherData(city);
    }
  }

  @override
  void dispose() {
    _cityName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (provider.error.isNotEmpty) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('error: ${provider.error}'),
                  ElevatedButton(onPressed: () {}, child: const Text('retry')),
                ],
              ),
            ),
          );
        }
        final weather = provider.weather!;
        final isNight = provider.isNight;
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: isNight
                    ? [const Color(0xFF0B1D3A), const Color(0xFF1B3B6F)]
                    : [const Color(0xFF77C5FF), const Color(0xFFEAF6FF)],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildDateHeader(isNight),
                    SizedBox(height: 15),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          colors: isNight
                              ? [
                                  const Color.fromARGB(255, 118, 137, 172),
                                  const Color.fromARGB(255, 25, 49, 87),
                                ]
                              : [
                                  const Color(0xFF77C5FF),
                                  const Color(0xFFEAF6FF),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            weather.cityName,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: isNight ? Colors.white : Colors.black,
                            ),
                          ),
                          //const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${weather.temp} °C',
                                style: TextStyle(
                                  fontSize: 40,
                                  color: isNight ? Colors.white : Colors.black,
                                ),
                              ),
                              SizedBox(width: 10),
                              Image.network(
                                'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
