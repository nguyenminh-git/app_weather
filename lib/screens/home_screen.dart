import 'package:app_weather/models/weather.dart';
import 'package:app_weather/services/weather_service.dart';
import 'package:app_weather/widgets/header_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cityName = TextEditingController(text: 'hanoi');
  final _weather = WeatherService();
  Future<Weather>? _futureWeather;

  @override
  void initState() {
    super.initState();
    _futureWeather = _weather.fechWeather(_cityName.text.trim());
  }

  void _seach() {
    final city = _cityName.text.trim();
    if (city.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('nhap ten thanh pho')));
      return;
    }
    setState(() {
      _futureWeather = _weather.fechWeather(city);
    });
  }

  @override
  void dispose() {
    _cityName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: Text('Weather',),
        centerTitle: true,
      ), */
      body: FutureBuilder<Weather>(
        future: _futureWeather,
        builder: (context, snapshot) {
          bool isNight = false;
          if (snapshot.hasData) {
            isNight = snapshot.data!.icon.endsWith('n');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return Text('No data');
          }
          final weather = snapshot.data!;
          return Container(
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
                              color: isNight? Colors.white:Colors.black
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
                                  color: isNight? Colors.white:Colors.black
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
          );
        },
      ),
    );
  }
}
