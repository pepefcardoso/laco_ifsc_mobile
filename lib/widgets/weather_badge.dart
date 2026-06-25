import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class WeatherBadge extends StatelessWidget {
  final String cityName;
  final double temperature;
  final String weatherIcon;

  const WeatherBadge({
    super.key,
    required this.cityName,
    required this.temperature,
    required this.weatherIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            weatherIcon,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 4),
          Text(
            '$cityName • ${temperature.toStringAsFixed(0)}°C',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.carvao,
            ),
          ),
        ],
      ),
    );
  }
}
