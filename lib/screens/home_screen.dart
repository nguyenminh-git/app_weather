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
  void initState(){
    super.initState();
    _futureWeather=_weather.fechWeather(_cityName.text.trim());
  }
  void _seach(){
    final city = _cityName.text.trim();
    if(city.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('nhap ten thanh pho')),
      );
      return;
    }
    setState(() {
      _futureWeather = _weather.fechWeather(city);
    });
  }
  @override
  void dispose(){
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 20,right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildDateHeader(),
              SizedBox(height: 10,),
              Container(
                child: TextField(
                  controller: _cityName,
                  decoration: InputDecoration(
                    hintText: 'Nhập tên thành phố',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),

                    ),
                    suffixIcon: IconButton(onPressed: _seach, icon: Icon(Icons.search))
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<Weather>(
                    future: _futureWeather, 
                    builder: (context,snapshot){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return CircularProgressIndicator();
                      }
                      if(snapshot.hasError){
                        return Text('Error: ${snapshot.error}');
                      }
                      if(!snapshot.hasData){
                        return Text('No data');
                      }
                      final weather = snapshot.data!;
                      return Column(
                        children: [
                          Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.blue[200],
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  weather.cityName,
                                  style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${weather.temp} °C',
                                      style: TextStyle(fontSize: 40),
                                    ),
                                    SizedBox(width: 10,),
                                    Image.network('https://openweathermap.org/img/wn/${weather.icon}@2x.png')
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  ),
                )
            ],
          ),
        ),
      )
    );
  }
}