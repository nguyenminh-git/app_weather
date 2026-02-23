import 'package:flutter/material.dart';

class InfoCapsule extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color iconColor;
  final Color textColor;
  final bool isNight;

  const InfoCapsule({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.iconColor,
    required this.textColor,
    required this.isNight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90, // Chiều rộng cố định để thẳng hàng
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isNight ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: textColor.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}