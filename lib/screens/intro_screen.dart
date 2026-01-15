import 'dart:async';
import 'package:app_weather/provider/weather_provider.dart';
import 'package:app_weather/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    _start();
    });
  }

  Future<void> _start() async {
    final weatherProvider = Provider.of<WeatherProvider>(context,listen: false);
    try {
      // chạy song song: fetch data + chờ 3s
      await Future.wait([
        weatherProvider.fectWeatherData('hanoi'),
        Future.delayed(const Duration(seconds: 3)),
      ]);

      if (!mounted) return;
 
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => HomeScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;

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
