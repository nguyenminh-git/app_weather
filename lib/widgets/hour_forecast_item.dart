import 'dart:ui'; // Cần cho ImageFilter
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/forecast.dart'; // Import model của bạn
import 'info_capsule.dart'; // Import widget con vừa tạo ở trên

class HourlyForecastItem extends StatelessWidget {
  final ForeCastItem item;
  final Color textColor;
  final Color subTextColor;
  final bool isNight;

  const HourlyForecastItem({
    super.key,
    required this.item,
    required this.textColor,
    required this.subTextColor,
    required this.isNight,
  });

  @override
  Widget build(BuildContext context) {
    // Logic tính toán để ở đây
    final int rainChance = (item.pop * 100).round();

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isNight
                ? Colors.white.withOpacity(0.08)
                : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(isNight ? 0.15 : 0.4),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            children: [
              // --- HÀNG TRÊN: Giờ, Icon, Nhiệt độ ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isNight 
                              ? Colors.white.withOpacity(0.1) 
                              : Colors.white.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          DateFormat('HH:mm').format(item.dateTime),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Image.network(
                        'https://openweathermap.org/img/wn/${item.icon}@2x.png',
                        width: 55,
                        height: 55,
                        errorBuilder: (_, __, ___) => Icon(Icons.cloud, color: subTextColor),
                      ),
                    ],
                  ),
                  Text(
                    '${item.temp.round()}°',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      height: 1.0,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(color: Colors.white24, height: 1),
              const SizedBox(height: 16),

              // --- HÀNG DƯỚI: Gọi các InfoCapsule ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InfoCapsule(
                    icon: Icons.water_drop_rounded,
                    value: '$rainChance%',
                    label: 'Rain',
                    iconColor: Colors.blueAccent,
                    textColor: textColor,
                    isNight: isNight,
                  ),
                  InfoCapsule(
                    icon: Icons.air_rounded,
                    value: '${item.windSpeed} m/s',
                    label: 'Wind',
                    iconColor: isNight ? Colors.grey[300]! : Colors.grey[700]!,
                    textColor: textColor,
                    isNight: isNight,
                  ),
                  InfoCapsule(
                    icon: Icons.water_rounded,
                    value: '${item.humidity}%',
                    label: 'Hum',
                    iconColor: Colors.lightBlueAccent,
                    textColor: textColor,
                    isNight: isNight,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}