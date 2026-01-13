/* import 'package:app_weather/services/weather_service.dart';

void main() async{
  print('Bat dau lay du lieu');
  final String cityName = 'danang';
  final service = WeatherService();
  final weatherData = await service.fechWeather(cityName);
  print('city:${weatherData.cityName}');
  print('temp:${weatherData.temp}C');
}
 */
import 'package:app_weather/screens/home_screen.dart';
import 'package:flutter/material.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        
      home: HomeScreen(),
    );
  }
}