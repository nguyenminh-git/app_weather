import 'package:app_weather/provider/weather_provider.dart';
import 'package:app_weather/screens/hourly_detail_screen.dart';
import 'package:app_weather/utils/forecast_helpdesk.dart';
import 'package:app_weather/widgets/forecast_list.dart';
import 'package:app_weather/widgets/header_widget.dart';
import 'package:app_weather/utils/city_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _cityName = TextEditingController();

  @override
  void dispose() {
    _cityName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, provider, child) {
        final isNight = provider.weather != null ? provider.isNight : false;
        
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: isNight
                    ? [const Color(0xFF0B1D3A), const Color(0xFF1B3B6F)]
                    : [const Color(0xFF77C5FF), const Color.fromARGB(255, 126, 156, 179)],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: buildDateHeader(isNight)),
                        IconButton(
                          padding: const EdgeInsets.only(top: 18),
                          icon: Icon(
                            Icons.my_location_rounded,
                            color: isNight ? Colors.white : Colors.black54,
                            size: 30,
                          ),
                          onPressed: () {
                            _cityName.clear();
                            context.read<WeatherProvider>().fetchWeatherByCurrentLocation();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    
                    // -- SEARCH BAR (Autocomplete) --
                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        return CityData.getSuggestions(textEditingValue.text);
                      },
                      onSelected: (String selection) {
                        // Người dùng đã chọn 1 mục
                        _cityName.text = selection;
                        provider.fetchWeatherData(selection);
                        // Đóng keyboard
                        FocusScope.of(context).unfocus();
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        // Giao diện danh sách thả xuống
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(15),
                            color: isNight 
                                ? const Color(0xFF1B3B6F) 
                                : Colors.white,
                            child: SizedBox(
                              height: 250,
                              width: MediaQuery.of(context).size.width - 40,
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                itemCount: options.length,
                                separatorBuilder: (context, index) => Divider(
                                  height: 1, 
                                  color: isNight ? Colors.white24 : Colors.black12,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  final String option = options.elementAt(index);
                                  return ListTile(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                    title: Text(
                                      option,
                                      style: TextStyle(
                                        color: isNight ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                    onTap: () {
                                      onSelected(option);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                        // Để icon lấy vị trí có thể xoá ô text, ta cần gán controller của autocomplete
                        // Nhưng vì framework ko cho gán ngược, nên ta cứ kệ tạm _cityName độc lập
                        // hoặc lắng nghe text của autocomplete.
                        
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          onSubmitted: (String value) {
                            if (value.trim().isNotEmpty) {
                              provider.fetchWeatherData(value.trim());
                            }
                          },
                          style: TextStyle(
                            color: isNight ? Colors.white : Colors.black87,
                          ),
                          decoration: InputDecoration(
                            hintText: "Tìm kiếm thành phố...",
                            hintStyle: TextStyle(
                              color: isNight ? Colors.white54 : Colors.black38,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: isNight ? Colors.white54 : Colors.black38,
                            ),
                            filled: true,
                            fillColor: isNight 
                              ? Colors.white.withOpacity(0.1) 
                              : Colors.black.withOpacity(0.05),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    SizedBox(height: 15),

                    // Nội dung thời tiết (Load/Lỗi/Thành công)
                    Expanded(
                      child: provider.isLoading 
                          ? const Center(child: CircularProgressIndicator(color: Colors.white,))
                          : provider.error.isNotEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.error_outline, size: 60, color: Colors.white70),
                                      SizedBox(height: 15),
                                      Text(
                                        'Không tìm thấy dữ liệu', 
                                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        provider.error, 
                                        style: TextStyle(color: Colors.white70, fontSize: 14),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                              : _buildWeatherContent(provider, context, isNight),
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

  Widget _buildWeatherContent(WeatherProvider provider, BuildContext context, bool isNight) {
    if (provider.weather == null) return const SizedBox();
    final weather = provider.weather!;
    final daily = pick5Days(provider.forecast);

    return Column(
      children: [
        GestureDetector(
          onTap: () {
                        final now = DateTime.now();
                        final todayHourly = provider.forecast.where((item) {
                          return item.dateTime.year == now.year &&
                              item.dateTime.month == now.month &&
                              item.dateTime.day == now.day;
                        }).toList();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HourlyDetailScreen(
                              cityName: weather.cityName,
                              selectedDate: now,
                              hourForecast: todayHourly,
                              isNight: isNight,
                            ),
                          ),
                        );
                      },
                      child: Container(
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
                                    color: isNight
                                        ? Colors.white
                                        : Colors.black,
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
                    ),
                    SizedBox(height: 15),
        Expanded(
          flex: 3,
          child: ForecastList(
            forecast: daily,
            isNight: isNight,
            // Hàm này sẽ chạy khi người dùng nhấn vào một dòng
            onDaySelected: (DateTime dateClicked) {
              // 1. Lấy danh sách gốc đầy đủ (chứa dữ liệu 3h/lần) từ Provider
              final allForecasts = provider.forecast;

              // 2. Lọc ra những mục trùng ngày/tháng/năm với ngày được chọn
              final detailsForDay = allForecasts.where((item) {
                return item.dateTime.year == dateClicked.year &&
                    item.dateTime.month == dateClicked.month &&
                    item.dateTime.day == dateClicked.day;
              }).toList();

              // 3. Chuyển sang màn hình chi tiết
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HourlyDetailScreen(
                    cityName: weather.cityName,
                    selectedDate: dateClicked,
                    hourForecast:
                        detailsForDay, // Truyền list đã lọc sang
                    isNight: isNight,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
