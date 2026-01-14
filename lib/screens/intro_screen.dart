import 'dart:async';
import 'package:app_weather/screens/home_screen.dart';
import 'package:app_weather/services/weather_service.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final _weatherService = WeatherService();
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    try {
      // chạy song song: fetch data + chờ 3s
      final results = await Future.wait([
        _weatherService.fechWeather('hanoi'),
        Future.delayed(const Duration(seconds: 3)),
      ]);

      final weather = results[0]; // Weather

      if (!mounted || _navigated) return;
      _navigated = true;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeScreen(initialWeather: weather),
        ),
      );
    } catch (e) {
      if (!mounted || _navigated) return;
      _navigated = true;

      // Nếu lỗi API thì vẫn vào HomeScreen (tự load lại) hoặc bạn tạo ErrorScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (_navigated) return;
          _navigated = true;

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [Color(0xFF77C5FF), Color(0xFFEAF6FF)],
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.wb_sunny, size: 100, color: Colors.white),
                SizedBox(height: 20),
                Text(
                  'Weather App',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
