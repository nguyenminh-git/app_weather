import 'dart:ui'; // Cần import để dùng ImageFilter
import 'package:app_weather/widgets/hour_forecast_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_weather/models/forecast.dart';

class HourlyDetailScreen extends StatelessWidget {
  final String cityName;
  final DateTime selectedDate;
  final List<ForeCastItem> hourForecast;
  final bool isNight;

  const HourlyDetailScreen({
    super.key,
    required this.cityName,
    required this.selectedDate,
    required this.hourForecast,
    required this.isNight,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'EEEE, d MMMM',
    ).format(selectedDate);
    final Color textColor = isNight ? Colors.white : Colors.black87;
    final Color subTextColor = isNight ? Colors.white70 : Colors.black54;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        // Thêm nền mờ cho AppBar để khi lướt xuống nội dung không bị rối mắt
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        title: Column(
          children: [
            Text(
              cityName,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 22, // Tăng nhẹ size
              ),
            ),
            Text(
              formattedDate,
              style: TextStyle(
                color: subTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            color: isNight
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: textColor, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, // Đổi hướng gradient dọc cho mượt
            end: Alignment.bottomCenter,
            colors: isNight
                ? [const Color(0xFF0B1D3A), const Color(0xFF2B4C7E)]
                : [const Color(0xFF89CFF0), const Color(0xFFEAF6FF)],
          ),
        ),
        child: SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            itemCount: hourForecast.length,
            // Tăng khoảng cách để các thẻ trông thoáng hơn
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final item = hourForecast[index];
              return HourlyForecastItem(
                item: item,
                textColor: textColor,
                subTextColor: subTextColor,
                isNight: isNight,
              );
            },
          ),
        ),
      ),
    );
  }
}
