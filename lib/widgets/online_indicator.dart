import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class OnlineIndicator extends StatelessWidget {
  final bool isOnline;

  const OnlineIndicator({
    super.key,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: isOnline ? AppColors.verdeSalvia : AppColors.cinzaMorno,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
      ),
    );
  }
}
