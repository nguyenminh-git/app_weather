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
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchFocusNode.removeListener(_onFocusChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;
    if (query.isNotEmpty && _searchFocusNode.hasFocus) {
      final results = CityData.getSuggestions(query);
      setState(() {
        _suggestions = results;
        _showSuggestions = results.isNotEmpty;
      });
    } else {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
      });
    }
  }

  void _onFocusChanged() {
    if (!_searchFocusNode.hasFocus) {
      // Delay nhỏ để cho phép onTap của ListTile chạy trước
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() => _showSuggestions = false);
        }
      });
    }
  }

  void _selectCity(String city, WeatherProvider provider) {
    _searchController.removeListener(_onSearchChanged);
    _searchController.text = city;
    _searchController.addListener(_onSearchChanged);
    setState(() => _showSuggestions = false);
    _searchFocusNode.unfocus();
    provider.fetchWeatherData(city);
  }

  Future<void> _navigateToDetail(Widget screen) async {
    // Ẩn gợi ý và unfocus trước khi navigate
    setState(() => _showSuggestions = false);
    _searchFocusNode.unfocus();

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
    // Khi quay về, không cần làm gì — _showSuggestions vẫn là false
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
                    : [
                        const Color(0xFF77C5FF),
                        const Color.fromARGB(255, 126, 156, 179),
                      ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                              _searchController.removeListener(
                                _onSearchChanged,
                              );
                              _searchController.clear();
                              _searchController.addListener(_onSearchChanged);
                              setState(() => _showSuggestions = false);
                              context
                                  .read<WeatherProvider>()
                                  .fetchWeatherByCurrentLocation();
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 15),

                      // -- SEARCH BAR --
                      TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onSubmitted: (String value) {
                          if (value.trim().isNotEmpty) {
                            _selectCity(value.trim(), provider);
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
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      // -- DROPDOWN GỢI Ý --
                      if (_showSuggestions && _suggestions.isNotEmpty)
                        Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(15),
                          clipBehavior: Clip.antiAlias,
                          color: isNight
                              ? const Color(0xFF1B3B6F)
                              : Colors.white,
                          surfaceTintColor: Colors.transparent,
                          child: SizedBox(
                            height: _suggestions.length > 4
                                ? 250
                                : _suggestions.length * 56.0,
                            width: double.infinity,
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemCount: _suggestions.length,
                              separatorBuilder: (context, index) => Divider(
                                height: 1,
                                color: isNight
                                    ? Colors.white24
                                    : Colors.black12,
                              ),
                              itemBuilder: (context, index) {
                                final city = _suggestions[index];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  title: Text(
                                    city,
                                    style: TextStyle(
                                      color: isNight
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  onTap: () => _selectCity(city, provider),
                                );
                              },
                            ),
                          ),
                        ),

                      SizedBox(height: 15),

                      // Nội dung thời tiết (Load/Lỗi/Thành công)
                      provider.isLoading
                          ? const Padding(
                              padding: EdgeInsets.only(top: 50.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : provider.error.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      size: 60,
                                      color: Colors.white70,
                                    ),
                                    const SizedBox(height: 15),
                                    const Text(
                                      'Không tìm thấy dữ liệu',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      provider.error,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : _buildWeatherContent(provider, context, isNight),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeatherContent(
    WeatherProvider provider,
    BuildContext context,
    bool isNight,
  ) {
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
            _navigateToDetail(
              HourlyDetailScreen(
                cityName: weather.cityName,
                selectedDate: now,
                hourForecast: todayHourly,
                isNight: isNight,
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
                    : [const Color(0xFF77C5FF), const Color(0xFFEAF6FF)],
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
        ),
        SizedBox(height: 15),
        ForecastList(
          forecast: daily,
          isNight: isNight,
          onDaySelected: (DateTime dateClicked) {
            final allForecasts = provider.forecast;
            final detailsForDay = allForecasts.where((item) {
              return item.dateTime.year == dateClicked.year &&
                  item.dateTime.month == dateClicked.month &&
                  item.dateTime.day == dateClicked.day;
            }).toList();

            _navigateToDetail(
              HourlyDetailScreen(
                cityName: weather.cityName,
                selectedDate: dateClicked,
                hourForecast: detailsForDay,
                isNight: isNight,
              ),
            );
          },
        ),
      ],
    );
  }
}
